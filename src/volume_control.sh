#!/bin/bash

muteStatus=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2)
if [ $muteStatus = "yes" ]; then
    echo "Muted"
    notify-send -h string:x-dunst-stack-tag:volume_change "Volume" "Muted"
    exit 0
fi

if [ -n "$1" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ "$1"
    currentVolume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume:" | cut -d '/' -f 2 | awk '{print $1}' | sed 's/%//g')
    notify-send -h string:x-dunst-stack-tag:volume_change -h int:value:$currentVolume "Volume" "$currentVolume%"
fi

currentVolume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume:" | cut -d '/' -f 2 | awk '{print $1}')

echo $currentVolume
