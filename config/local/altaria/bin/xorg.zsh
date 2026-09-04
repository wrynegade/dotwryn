#!/bin/zsh
#####################################################################

graphics_cards_detected="$(xrandr | sed -n 's/\(DP-[0-9]-\).*$/\1/p' | sort -u | wc -l)"

case "${graphics_cards_detected}" in
	( 1 )  # sometimes the graphics card on the motherboard is detected and becomes primary
		XRANDR_OUTPUT__splitter='HDMI-1-0'
		XRANDR_OUTPUT__desk='unknown -> probably wont come up but future me needs to put this in manually'
		XRANDR_OUTPUT__house='DP-1-4'
		XRANDR_OUTPUT__zapdos='DP-1-0'
		XRANDR_OUTPUT__server_rack='HDMI2'
		;;

	( 0 | * )  # default: just the dedicated graphics card detected
		XRANDR_OUTPUT__splitter='HDMI-0'
		XRANDR_OUTPUT__desk='DP-2'
		XRANDR_OUTPUT__zapdos='DP-0'
		XRANDR_OUTPUT__server_rack='DP-4'
		;;
esac

XRANDR_OUTPUTS=()
for XRANDR_OUTPUT in \
	splitter \
	desk \
	zapdos \
	server_rack \
	;
do
	XRANDR_OUTPUT_var=XRANDR_OUTPUT__${XRANDR_OUTPUT}
	XRANDR_OUTPUTS+=("${(P)XRANDR_OUTPUT_var}")
done

I3_DEFAULT_THEME_BACKGROUND=$(scwrypts -n get theme).png

MONITOR_CONFIGURATION=unknown

: \
	&& xrandr --query | grep -q "^${XRANDR_OUTPUT__splitter} connected" \
	&& MONITOR_CONFIGURATION=home \
	;
	#&& xrandr --query | grep -q "^${XRANDR_OUTPUT__house} connected" \

#####################################################################

case $1 in
	( 1080 | 1080p )
		XRANDR_MODE=(--mode 1920x1080)
		XRANDR_OFFSET_X=1920
		XRANDR_OFFSET_Y=1080

		EXTRA_ARGS__splitter=()
		EXTRA_ARGS__desk=()
		EXTRA_ARGS__house=()
		EXTRA_ARGS__zapdos=()

		I3_BACKGROUND=link-vs-gdizz.jpg
		;;

	( 1440 | 1440p | 2k | guild-wars-2 )
		XRANDR_MODE=(--mode 2560x1440)
		XRANDR_OFFSET_X=2560
		XRANDR_OFFSET_Y=1440

		EXTRA_ARGS__splitter=()
		EXTRA_ARGS__desk=()
		EXTRA_ARGS__zapdos=(--rate 120.00)

		I3_BACKGROUND=roy-art.jpg
		;;

	( 2160 | 2160p | 4k | '' )  # default for the RTX5080
		XRANDR_MODE=(--mode 3840x2160)
		XRANDR_OFFSET_X=3840
		XRANDR_OFFSET_Y=2160

		EXTRA_ARGS__splitter=(--rate 119.88)
		EXTRA_ARGS__desk=(--rate 119.88) # make it match
		EXTRA_ARGS__house=()
		#EXTRA_ARGS__zapdos=(--rate 143.99)  # I thought this was a bad cable... apparently this is a MANUFACTURERS error -> they messed up the OS software and I'm big mad at LG

		I3_BACKGROUND=${I3_DEFAULT_THEME_BACKGROUND[@]}
		;;

	( max )  # use only for desk gaming
		XRANDR_MODE=(--mode 3840x2160)
		XRANDR_OFFSET_X=3840
		XRANDR_OFFSET_Y=2160
		
		EXTRA_ARGS__desk=(--rate 239.99)
		;;

	( * )
		echo "error : unknown resolution '$1'"
		exit 1
		;;
esac


XRANDR_ARGS__splitter=(--output ${XRANDR_OUTPUT__splitter[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__splitter[@]})
XRANDR_ARGS__desk=(--output ${XRANDR_OUTPUT__desk[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__desk})
XRANDR_ARGS__house=(--output ${XRANDR_OUTPUT__house[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__house[@]})
XRANDR_ARGS__zapdos=(--output ${XRANDR_OUTPUT__zapdos[@]} ${XRANDR_MODE[@]} ${EXTRA_ARGS__zapdos[@]})

##########################################

source ${HOME}/.config/wryn/env.zsh
export DISPLAY=:0

###############################################################################

XRANDR_SET() {
	local ERRORS=0

	local COMPOSITING=enable
	local SCREEN_BLANK=enable
	local BACKGROUND=${I3_BACKGROUND}
	local SOUND_EFFECT=login
	local XRANDR_ARGS=()

	local enable_server_rack=false

	while [[ $# -gt 0 ]]
	do
		case $1 in
			( --compositing  ) COMPOSITING="$2"  ; shift 1 ;;
			( --screen-blank ) SCREEN_BLANK="$2" ; shift 1 ;;
			( --background   ) BACKGROUND="$2"   ; shift 1 ;;
			( --sound-effect ) SOUND_EFFECT="$2" ; shift 1 ;;

			( --server-rack  ) enabled_server_rack=true ;;

			( * ) XRANDR_ARGS+=($1) ;
		esac
		shift 1
	done

	local xrandr_output xrandr_output_should_turn_off
	for xrandr_output in "${XRANDR_OUTPUTS[@]}"
	do
		[[ "${XRANDR_ARGS[(re)${xrandr_output}]}" == "${xrandr_output}" ]] \
			&& xrandr_output_should_turn_off=false \
			|| xrandr_output_should_turn_off=true \
			;

		[[ "${xrandr_output_should_turn_off}" == true ]] \
			&& XRANDR_ARGS+=(--output "${xrandr_output}" --off)
	done

	if [[ "${XRANDR_OUTPUT__server_rack}" ]]
	then
		case "${enable_server_rack}" in
			( true  ) XRANDR_ARGS+=(--output "${XRANDR_OUTPUT__server_rack}" --auto) ;;
			( false ) XRANDR_ARGS+=(--output "${XRANDR_OUTPUT__server_rack}" --off) ;;
		esac
	fi

	case "${COMPOSITING}" in
		( enable  ) (pkill compton; sleep 1; compton;) & ;;
		( disable ) pkill compton ;;
		( * )
			echo "ERROR : invalid setting '${COMPOSITING}' for compositing" >&2
			return 1
	esac

	case "${SCREEN_BLANK}" in
		( enable | disable ) ;;
		( * )
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
