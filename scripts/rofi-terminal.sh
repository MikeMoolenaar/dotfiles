#!/bin/bash
zsh -ci "source ~/.config/rofi/terminal.sh && $(rofi -dmenu -p 'Run command' -theme-str 'listview {lines: 0;}')"
