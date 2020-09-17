#!/bin/sh


# Positions
# MONITOR     | ORIENTATION | POSITION
# ------------|-------------|----------
# DP-1 / DP-0 | ANY         | 0x0
# DP-2        | DP-1/0:NORM | 5760x0
# DP-2        | DP-1/0:LEFT | 3240x0
# DP-3 / DP-4 | NORMAL      | 2880x0
# DP-3 / DP-4 | RIGHT       | 1620x0
# HDMI-0      | DP-1/0:NORM | 8640x0
# HDMI-0      | DP-1/0:LEFT | 5533x0

if xrandr | grep -q "DP-0 connected"; then
	xrandr \
		--output DP-0 --mode 1920x1080 --scale 1.5x1.5 --primary\
					  --pos 0x0 --rotate left\
		--output DP-1 --off\
		--output DP-2 --mode 2880x1800--rotate normal --scale 0.8x0.8\
					  --pos 3240x0\
		--output DP-3 --off\
		--output DP-4 --mode 1920x1080 --scale 1.5x1.5\
					  --pos 1620x0 --rotate right\
		--output HDMI-0 --mode 1920x1080 --rotate left\
				        --pos 5544x0\
		--setmonitor BigBoi auto DP-0,DP-4\
	;
else
	xrandr \
		--output DP-0 --off\
		--output DP-1 --mode 1920x1080 --scale 1.5x1.5 --primary\
			          --pos 0x0 --rotate left\
		--output DP-2 --mode 2880x1800 --scale 0.8x0.8\
			          --pos 3240x0 --rotate normal\
		--output DP-3 --mode 1920x1080 --scale 1.5x1.5\
			          --pos 1620x0 --rotate right\
		--output DP-4 --off\
		--output HDMI-0 --mode 1920x1080\
			            --pos 5544x0 --rotate left\
		--setmonitor BigBoi auto DP-1,DP-3\
	;
fi

feh --bg-fill --randomize $HOME/Pictures/bg >/dev/null 2>&1;
