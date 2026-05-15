-- https://wiki.hypr.land/Configuring/Start/

-- Load machine-specific config: set MYENV to "home", "laptop", or "work" in /etc/environment
local env = os.getenv("MYENV") or "home"
require(env)


------------------
---- AUTOSTART ----
------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("vicinae server")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },

    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = "rgba(349ec1ee)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity   = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 5,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4,  bezier = "default" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + C",            hl.dsp.window.close())
hl.bind(mainMod .. " + M",            hl.dsp.exit())
hl.bind(mainMod .. " + U",            hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + SHIFT + U",    hl.dsp.exec_cmd("shutdown now"))
hl.bind(mainMod .. " + V",            hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F",            hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + O",            hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind(mainMod .. " + T",            hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab",          hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + F",    hl.dsp.window.fullscreen())
hl.bind("CTRL + SHIFT + L",           hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 1 && hyprlock"))

-- Move focus with vim-style keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch and move windows with SHIFT + vim-style keys
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces, move windows to workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind("Print",       hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast --notify copysave output"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- No border/rounding when only one window is on screen (smart gaps)
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name  = "no-border-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-border-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

-- Firefox: always full opacity
hl.window_rule({
    name  = "firefox",
    match = { class = "firefox" },

    opacity = "1.0 override",
})

-- Rider: always full opacity
hl.window_rule({
    name  = "rider",
    match = { class = "jetbrains-rider" },

    opacity = "1.0 override",
})

-- Rider: fix tooltips with win* titles
hl.window_rule({
    name  = "rider-tooltips",
    match = {
        class = "jetbrains-rider",
        title = "^(win.*)$",
    },

    no_initial_focus = true,
    no_focus         = true,
})

-- Rider: fix tab dragging
hl.window_rule({
    name  = "rider-tab-dragging",
    match = {
        class = "jetbrains-rider",
        title = "^\\s$",
    },

    no_initial_focus = true,
    no_focus         = true,
})

-- ueberzugpp: float the overlay window so Yazi image preview works
hl.window_rule({
    name  = "ueberzugpp-float",
    match = { title = "^ueberzugpp_.*" },

    float            = true,
    no_focus         = true,
    no_initial_focus = true,
})

hl.layer_rule({
    name  = "vicinae-blur",
    match = { namespace = "vicinae" },

    blur         = true,
    ignore_alpha = 0,
})
