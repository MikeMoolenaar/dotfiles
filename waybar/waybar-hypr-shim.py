#!/usr/bin/env python3
"""Launch Waybar behind a Hyprland IPC shim that fixes workspace clicks.

Hyprland >= 0.56 with a Lua config evaluates the payload of a socket1
``dispatch`` request as Lua, so Waybar's built-in workspace clicks
(``dispatch workspace 3``) fail with a Lua syntax error and nothing happens.
See https://github.com/Alexays/Waybar/issues/5008. Is fixed in the next waybar update.

This wrapper serves a fake ``.socket.sock`` in a shim instance directory and
points Waybar at it via HYPRLAND_INSTANCE_SIGNATURE. The legacy dispatches
Waybar emits are rewritten into their ``hl.dsp.*`` equivalents; everything
else is forwarded untouched. Delete this file and go back to launching
``waybar`` directly once Waybar speaks the Lua dispatch API.
"""

import json
import os
import shutil
import signal
import socket
import subprocess
import sys
import threading

DEBUG = os.environ.get("WAYBAR_SHIM_DEBUG") == "1"
RECV_MAX = 65536


def log(*a):
    if DEBUG:
        print("[waybar-hypr-shim]", *a, file=sys.stderr, flush=True)


def lua_value(arg: str) -> str:
    """Workspace ids stay numbers; anything else becomes a Lua string."""
    if arg.lstrip("+-").isdigit():
        return arg
    # json.dumps gives us a quoted, escaped literal Lua also accepts.
    return json.dumps(arg)


# Legacy dispatchers Waybar emits -> Lua equivalents, verified against
# Hyprland 0.56.2. `focusworkspaceoncurrentmonitor` has no Lua counterpart
# yet, so it degrades to a plain workspace focus.
DISPATCHERS = {
    "workspace": lambda a: f"hl.dsp.focus({{ workspace = {lua_value(a)} }})",
    "focusworkspaceoncurrentmonitor": lambda a: f"hl.dsp.focus({{ workspace = {lua_value(a)} }})",
    "movetoworkspace": lambda a: f"hl.dsp.window.move({{ workspace = {lua_value(a)} }})",
    "movetoworkspacesilent": lambda a: f"hl.dsp.window.move({{ workspace = {lua_value(a)}, silent = true }})",
    "togglespecialworkspace": lambda a: f"hl.dsp.workspace.toggle_special({json.dumps(a)})"
    if a
    else "hl.dsp.workspace.toggle_special()",
    "focuswindow": lambda a: f"hl.dsp.focus({{ window = {json.dumps(a)} }})",
    "focusmonitor": lambda a: f"hl.dsp.focus({{ monitor = {json.dumps(a)} }})",
}


def rewrite(request: str) -> str:
    """Turn `[flags/]dispatch <legacy args>` into a Lua dispatch."""
    head, _, _ = request.partition(" ")
    prefix, body = "", request
    if "/" in head:  # e.g. "j/workspaces", "-j/dispatch ..."
        prefix, _, body = request.partition("/")
        prefix += "/"

    if not body.startswith("dispatch "):
        return request

    payload = body[len("dispatch ") :].strip()
    # Already Lua, or a batch we should not touch.
    if payload.startswith("hl.") or payload.startswith("[[BATCH]]"):
        return request

    name, _, args = payload.partition(" ")
    build = DISPATCHERS.get(name)
    if build is None:
        log("no Lua mapping for dispatcher:", payload)
        return request

    return f"{prefix}dispatch {build(args.strip())}"


def serve(client: socket.socket, real_socket: str):
    with client:
        try:
            request = client.recv(RECV_MAX)
            if not request:
                return
            # Hyprland itself treats one read as one request, so we do too.
            forwarded = rewrite(request.decode("utf-8", "replace")).encode()
            if forwarded != request:
                log("rewrote:", request, "->", forwarded)

            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as upstream:
                upstream.connect(real_socket)
                upstream.sendall(forwarded)
                while True:
                    chunk = upstream.recv(RECV_MAX)
                    if not chunk:
                        break
                    client.sendall(chunk)
        except OSError as e:
            log("proxy error:", e)


def main() -> int:
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if not his or not runtime:
        print(
            "waybar-hypr-shim: no Hyprland instance in env, running waybar directly",
            file=sys.stderr,
        )
        os.execvp("waybar", ["waybar", *sys.argv[1:]])

    real_dir = os.path.join(runtime, "hypr", his)
    shim_his = f"{his}.waybar-shim"
    shim_dir = os.path.join(runtime, "hypr", shim_his)

    shutil.rmtree(shim_dir, ignore_errors=True)
    os.makedirs(shim_dir, exist_ok=True)
    # Events come straight from Hyprland; only dispatches need rewriting.
    os.symlink(os.path.join(real_dir, ".socket2.sock"), os.path.join(shim_dir, ".socket2.sock"))

    listen_path = os.path.join(shim_dir, ".socket.sock")
    real_socket = os.path.join(real_dir, ".socket.sock")

    listener = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    listener.bind(listen_path)
    listener.listen(16)

    def accept_loop():
        while True:
            try:
                client, _ = listener.accept()
            except OSError:
                return
            threading.Thread(target=serve, args=(client, real_socket), daemon=True).start()

    threading.Thread(target=accept_loop, daemon=True).start()
    log("listening on", listen_path)

    env = dict(os.environ, HYPRLAND_INSTANCE_SIGNATURE=shim_his)
    child = subprocess.Popen(["waybar", *sys.argv[1:]], env=env)

    def forward(signum, _frame):
        child.send_signal(signum)

    for sig in (signal.SIGTERM, signal.SIGINT, signal.SIGUSR1, signal.SIGUSR2, signal.SIGHUP):
        signal.signal(sig, forward)

    try:
        return child.wait()
    finally:
        listener.close()
        shutil.rmtree(shim_dir, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
