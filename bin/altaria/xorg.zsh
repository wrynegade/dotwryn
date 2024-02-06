#!/bin/zsh
source $HOME/.config/wryn/env.zsh

export DISPLAY=:0

#####################################################################

XRANDR_RESOLUTION__4k='3840x2160'
XRANDR_RESOLUTION__2k='2560x1440'
XRANDR_RESOLUTION__1080p='1920x1080'

XRANDR_OUTPUT__office='DP-0'
XRANDR_OUTPUT__livingroom='HDMI-0'

XRANDR_ARGS__office__4k=(--output $XRANDR_OUTPUT__office --mode $XRANDR_RESOLUTION__4k)
#XRANDR_ARGS__office__2k=()  # not available on office monitor
XRANDR_ARGS__office__1080p=(--output $XRANDR_OUTPUT__office --mode $XRANDR_RESOLUTION__1080p)

XRANDR_ARGS__livingroom__4k=(--output $XRANDR_OUTPUT__livingroom --mode $XRANDR_RESOLUTION__4k --rate 119.88)
XRANDR_ARGS__livingroom__2k=(--output $XRANDR_OUTPUT__livingroom --mode $XRANDR_RESOLUTION__2k)
XRANDR_ARGS__livingroom__1080p=(--output $XRANDR_OUTPUT__livingroom --mode $XRANDR_RESOLUTION__1080p)

#####################################################################

XRANDR_SET() {
	local ERRORS=0

	local COMPOSITING=enable
	local SCREEN_BLANK=enable
	local BACKGROUND=purple.jpg
	local SOUND_EFFECT=login
	local XRANDR_ARGS=()

	while [[ $# -gt 0 ]]
	do
		case $1 in
			--compositing  ) COMPOSITING="$2"  ; shift 1 ;;
			--screen-blank ) SCREEN_BLANK="$2" ; shift 1 ;;
			--background   ) BACKGROUND="$2"   ; shift 1 ;;
			--sound-effect ) SOUND_EFFECT="$2" ; shift 1 ;;

			* ) XRANDR_ARGS+=($1) ;
		esac
		shift 1
	done

	case $COMPOSITING in
		enable  ) (pkill compton; sleep 1; compton;) & ;;
		disable ) pkill compton ;;
		* )
			echo "ERROR : invalid setting '$COMPOSITING' for compositing" >&2
			return 1
	esac

	case $SCREEN_BLANK in
		enable | disable ) ;;
		* )
			echo "ERROR : invalid setting '$SCREEN_BLANK' for screen blank" >&2
			return 1
	esac

	##########################################

	scwrypts desktop/xrandr/disconnect-all

	xrandr ${XRANDR_ARGS[@]} 

	sleep 1

	scwrypts desktop/screen-blank      -- $SCREEN_BLANK
	scwrypts desktop/i3/set-background -- $BACKGROUND
	scwrypts desktop/play-sound        -- $SOUND_EFFECT
}
