#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while true; do
	currentStatus=$($SCRIPT_DIR/dwm_status.sh)
	xsetroot -name "$currentStatus"
	sleep 2
done
