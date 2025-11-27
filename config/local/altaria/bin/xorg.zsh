#!/bin/zsh
#####################################################################

XRANDR_OUTPUT__splitter='HDMI-0'
XRANDR_OUTPUT__desk='DP-4'

I3_DEFAULT_THEME_BACKGROUND=$(scwrypts -n get theme).png

MONITOR_CONFIGURATION=unknown

: \
	&& xrandr --query | grep -q "^${XRANDR_OUTPUT__splitter} connected" \
	&& MONITOR_CONFIGURATION=home \
	;
	#&& xrandr --query | grep -q "^${XRANDR_OUTPUT__desk} connected" \

#####################################################################

case $1 in
	( 1080 | 1080p )
		XRANDR_MODE=(--mode 1920x1080)
		XRANDR_OFFSET_X=1920
		XRANDR_OFFSET_Y=1080

		EXTRA_ARGS__splitter=()
		EXTRA_ARGS__desk=()

		I3_BACKGROUND=link-vs-gdizz.jpg
		;;

	( 1440 | 1440p | 2k )
		XRANDR_MODE=(--mode 2560x1440)
		XRANDR_OFFSET_X=2560
		XRANDR_OFFSET_Y=1440

		EXTRA_ARGS__splitter=(--rate 120.00)
		EXTRA_ARGS__desk=(--rate 120.00)

		I3_BACKGROUND=roy-art.jpg
		;;

	( 2160 | 2160p | 4k | '' )  # default for the RTX5080
		XRANDR_MODE=(--mode 3840x2160)
		XRANDR_OFFSET_X=3840
		XRANDR_OFFSET_Y=2160

		EXTRA_ARGS__splitter=(--rate 120.00)
		EXTRA_ARGS__desk=(--rate 120.00)

		I3_BACKGROUND=${I3_DEFAULT_THEME_BACKGROUND[@]}
		;;

	( * )
		echo "error : unknown resolution '$1'"
		exit 1
		;;
esac


XRANDR_ARGS__splitter=(--output ${XRANDR_OUTPUT__splitter[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__splitter[@]})
XRANDR_ARGS__desk=(--output ${XRANDR_OUTPUT__desk[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__desk[@]})

##########################################

source ${HOME}/.config/wryn/env.zsh
export DISPLAY=:0

###############################################################################

XRANDR_OFF() {
	local MONITOR ARGS=()
	for MONITOR in $@
	do
		MONITOR="XRANDR_OUTPUT__${MONITOR}"
		ARGS+=(--output ${(P)MONITOR} --off)
	done

	xrandr ${ARGS[@]}
}

XRANDR_SET() {
	local ERRORS=0

	local COMPOSITING=enable
	local SCREEN_BLANK=enable
	local BACKGROUND=${I3_BACKGROUND}
	local SOUND_EFFECT=login
	local XRANDR_ARGS=()

	while [[ $# -gt 0 ]]
	do
		case $1 in
			( --compositing  ) COMPOSITING="$2"  ; shift 1 ;;
			( --screen-blank ) SCREEN_BLANK="$2" ; shift 1 ;;
			( --background   ) BACKGROUND="$2"   ; shift 1 ;;
			( --sound-effect ) SOUND_EFFECT="$2" ; shift 1 ;;

			( * ) XRANDR_ARGS+=($1) ;
		esac
		shift 1
	done

	case ${COMPOSITING} in
		( enable  ) (pkill compton; sleep 1; compton;) & ;;
		( disable ) pkill compton ;;
		* )
			echo "ERROR : invalid setting '${COMPOSITING}' for compositing" >&2
			return 1
	esac

	case ${SCREEN_BLANK} in
		enable | disable ) ;;
		* )
			echo "ERROR : invalid setting '${SCREEN_BLANK}' for screen blank" >&2
			return 1
	esac

	##########################################

	# disabling for a moment since the latest X11/NVIDIA drivers are causing some issues after "disconnect all"
	#scwrypts desktop xrandr disconnect all

	xrandr ${XRANDR_ARGS[@]} 

	sleep 1

	scwrypts desktop screen blank      -- ${SCREEN_BLANK}
	scwrypts desktop i3 set background -- ${BACKGROUND} || scwrypts desktop i3 set background -- purple.jpg
	"${DOTWRYN}/bin/polybar"
	scwrypts media play sfx            -- ${SOUND_EFFECT}
}
