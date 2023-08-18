CLIPBOARD=$(xsel)
xdotool search --onlyvisible --name firefox windowactivate
firefox --new-tab "https://duckduckgo.com/?q=$CLIPBOARD"

