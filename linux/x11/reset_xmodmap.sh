#!/bin/bash

remap() {
    local remapped=$(xmodmap -pke | grep 134 | grep Alt -c)
    if [[ $remapped -ne 1 ]]; then
	echo "Remapping!"
    	xmodmap ~/.config/X11/xmodmap_hhkb
    fi
}

while true; do
    sleep 5
    remap
done

