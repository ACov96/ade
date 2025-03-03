#!/bin/bash

if [ -n "$1" ]; then
    currentBrightness=$(brightnessctl set $1 | grep "Current brightness:" | awk '{print $4}' | sed 's/(//g' | sed 's/)//g')
    notify-send -h string:x-dunst-stack-tag:brightness_change -h int:value:$currentBrightness "Brightness" "$currentBrightness"
fi

currentBrightness=$(brightnessctl i | grep "Current brightness:" | awk '{print $4}' | sed 's/(//g' | sed 's/)//g')
