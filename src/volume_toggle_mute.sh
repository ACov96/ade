#!/bin/bash

muteStatus=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2)
if [ $muteStatus = "yes" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ 0
    notify-send -h string:x-dunst-stack-tag:volume_change "Volume" "Unmuted"
else
    pactl set-sink-mute @DEFAULT_SINK@ 1
    notify-send -h string:x-dunst-stack-tag:volume_change "Volume" "Muted"
fi
