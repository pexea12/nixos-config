#!/usr/bin/env bash

bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$bluetooth_status" = "yes" ]; then
    # Check if any device is connected
    connected_device=$(bluetoothctl devices Connected | head -n 1)
    if [ -n "$connected_device" ]; then
        device_name=$(echo "$connected_device" | cut -d' ' -f3-)
        echo " $device_name"
    else
        echo ""
    fi
else
    echo ""
fi
