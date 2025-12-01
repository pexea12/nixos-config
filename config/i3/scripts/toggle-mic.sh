#!/usr/bin/env bash

# Toggle microphone mute and control LED

# Toggle the microphone using wpctl (PipeWire)
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
    # Muted - turn LED ON
    brightnessctl --device='platform::micmute' set 1
else
    # Unmuted - turn LED OFF
    brightnessctl --device='platform::micmute' set 0
fi
