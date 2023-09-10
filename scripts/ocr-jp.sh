#!/bin/bash

# Uncomment this line when running script as a Gnome keyboard shortcut (see Settings > Keyboard > Customise Shortcuts)
cd "$(dirname "$0")"

output_file="./output.png"

flameshot gui --path $output_file 2> /dev/null

if [ -f $output_file ] 
then
    ocr_out=`wine ./Capture2Text/Capture2Text_CLI.exe  -i ./$output_file  --l Japanese $@`
    echo $ocr_out | xclip -selection c
    rm $output_file
fi
