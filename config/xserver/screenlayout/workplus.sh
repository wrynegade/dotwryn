#!/bin/sh
if xrandr | grep -q "DP-0 connected"; then
	xrandr \
		--output DP-0 --mode 1920x1080 --pos 0x0    --rotate normal --scale 1.5x1.5 --primary\
		--output DP-1 --off\
		--output DP-2 --mode 2880x1800 --pos 5760x0 --rotate normal --scale 0.8x0.8\
		--output DP-3 --off\
		--output DP-4 --mode 1920x1080 --pos 2880x0 --rotate normal --scale 1.5x1.5\
		--output HDMI-0 --mode 1920x1080 --pos 8640x0 --rotate left\
	;
else
	xrandr \
		--output DP-0 --off\
		--output DP-1 --mode 1920x1080 --pos 0x0    --rotate normal --scale 1.5x1.5 --primary\
		--output DP-2 --mode 2880x1800 --pos 5760x0 --rotate normal --scale 0.8x0.8\
		--output DP-3 --mode 1920x1080 --pos 2880x0 --rotate normal --scale 1.5x1.5\
		--output DP-4 --off\
		--output HDMI-0 --mode 1920x1080 --pos 8640x0 --rotate left\
	;
fi

feh --bg-fill --randomize $HOME/Pictures/bg >/dev/null 2>&1;
