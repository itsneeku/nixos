#!/bin/bash

# Check the Bluetooth "Powered" status using bluetoothctl and awk
powered_status=$(bluetoothctl show | awk '/Powered:/ {print $2}')

if [ "$powered_status" == "yes" ]; then
    echo "Bluetooth is currently enabled. Turning it off..."
    bluetoothctl power off
else
    echo "Bluetooth is currently disabled. Turning it on..."
    bluetoothctl power on
fi
