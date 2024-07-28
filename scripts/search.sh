YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool click 0xC2 # Middle button
CLIPBOARD=$(wl-paste -p)
xdotool search --onlyvisible --name firefox windowactivate
firefox --new-tab "https://duckduckgo.com/?q=$CLIPBOARD"

