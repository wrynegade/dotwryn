#!/bin/sh
xrandr --output DP-0 --off --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DP-2 --mode 2880x1800 --pos 3840x0 --rotate normal --output DP-3 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-4 --off

xrandr --output DP-2 --scale 0.7x0.7 && feh --bg-fill $HOME/Pictures/bg/vegeta.jpg $HOME/Pictures/bg/altaria.jpg $HOME/Pictures/bg/captainfalcon.jpg >/dev/null 2>/dev/null
