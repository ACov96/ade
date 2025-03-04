#!/bin/bash

# A bash script that outputs the status line for my dwm system.
# This script only outputs the line once to stdout and then exits. 
# It is intended to be consumed by a daemon.


##################
# Network Status #
##################
networkStatus=$(iwctl station wlan0 show | grep "State" | tr -s ' ' | awk '{$1=$1; print}' | cut -d ' ' -f 2)

# Get the list of network interfaces
interfaces=$(ip -o link show | awk -F': ' '{print $2}')

# Initialize variables
ethernet_connected=false
wifi_connected=false

# Check each interface
for interface in $interfaces; do
    # Check if the interface is Ethernet (usually starts with "en" or "eth")
    if [[ $interface == en* || $interface == eth* ]]; then
        if ip link show $interface | grep -q "state UP"; then
            ethernet_connected=true
        fi
    fi

    # Check if the interface is Wi-Fi (usually starts with "wl" or "wlan")
    if [[ $interface == wl* || $interface == wlan* ]]; then
        if ip link show $interface | grep -q "state UP"; then
            wifi_connected=true
        fi
    fi
done

# Determine the output
if $ethernet_connected; then
    networkOutput="Ethernet"
elif $wifi_connected; then
    networkName=$(iwctl station wlan0 show | grep "Connected network" | awk '{$1=$1; print}' | sed 's/Connected network //')
    networkOutput="$networkName 🛜"
else
    networkOutput="Not connected"
fi


###########
# Battery #
###########

batteryPath=$(compgen -G "/sys/class/power_supply/BAT*/" | head -n1)
if [ -n $batteryPath ]; then
    batteryPercentage=$(cat $batteryPath/capacity)
    batteryStatus=$(cat $batteryPath/status)
    
    case $batteryStatus in
    	"Discharging")
    		batteryIcon=$([[ $batteryPercentage -le 20 ]] && echo "🪫" || echo "🔋")
    		;;
    	"Charging")
    		batteryIcon="🔌"
    		;;
    	"Full")
    		batteryIcon="⚡"
    		;;
    	*)
    		batteryIcon="($batteryStatus)"
    		;;
    esac
    batteryOutput="$batteryPercentage% $batteryIcon"
else
    batteryOutput="No battery"
fi

#################
# Date and Time #
#################
dateTimeOutput=$(date +"%I:%M %p - %F")

###############
# System Info #
###############
memory_gib=$(free -b | grep "Mem:" | tr -s ' ' | cut -d ' ' -f 3 | xargs numfmt --to=iec --suffix=B)
memory_max_gib=$(free -b | grep "Mem:" | tr -s ' ' | cut -d ' ' -f 2 | xargs numfmt --to=iec --suffix=B)
memoryOutput="MEM: $memory_gib / $memory_max_gib"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
cpu_frequency=$(awk -F': ' '/cpu MHz/ {printf "%.2f GHz", $2/1000; exit}' /proc/cpuinfo)
cpuOutput="CPU: $cpu_frequency, $cpu_usage%"

systemInfoOutput="$cpuOutput - $memoryOutput"

##########
# Volume #
##########
currentVolume=$(volume_control.sh)
volumePercent=$(echo $currentVolume | sed 's/%//g')

if [ $currentVolume = "Muted" ]; then
    volumeIcon="🔇"
else
    if (( volumePercent >= 66 )); then
        volumeIcon="🔊"
    elif (( volumePercent >= 33 )); then
        volumeIcon="🔉"
    else
        volumeIcon="🔈"
    fi
fi

volumeOutput="$currentVolume $volumeIcon"

################
# Final Output #
################
statusString="$systemInfoOutput | $networkOutput | $volumeOutput | $batteryOutput | $dateTimeOutput"

echo -e " $statusString "
