#!/usr/bin/env bash

if [ -f /sys/class/power_supply/ADP1/online ]; then
    on_ac=$(cat /sys/class/power_supply/ADP1/online)
elif [ -f /sys/class/power_supply/AC/online ]; then
    on_ac=$(cat /sys/class/power_supply/AC/online)
else
    on_ac=0
fi

governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")

# Get platform profile if available (AMD specific)
if [ -f /sys/firmware/acpi/platform_profile ]; then
    platform_profile=$(cat /sys/firmware/acpi/platform_profile)
else
    platform_profile=""
fi

if [ "$on_ac" = "1" ]; then
    icon="󱐋"
    if [ "$governor" = "performance" ]; then
        label="Performance"
    else
        label="AC ($governor)"
    fi
else
    icon="󰁹"
    if [ "$governor" = "powersave" ]; then
        label="Power Save"
    else
        label="Battery ($governor)"
    fi
fi

if [ -n "$platform_profile" ]; then
    case "$platform_profile" in
        "low-power")
            label="$label 󰾅"
            ;;
        "balanced")
            label="$label 󰾆"
            ;;
        "performance")
            label="$label 󰓅"
            ;;
    esac
fi

echo "$icon $label"
