#!/bin/bash

if [[ "$(playerctl -p spotify status)" = "Playing"  ]]; then
    uwsm app -- hyprlock --config ~/.config/hyprlock/music.conf
else
    uwsm app -- hyprlock 
fi 

