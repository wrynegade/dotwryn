#!/bin/zsh
#####################################################################

use notify
use audio/play-sfx --group media

DEPENDENCIES+=(pactl)

#####################################################################

${scwryptsmodule}() {
	local SCWRYPTS_NOTIFICATION_ENGINES=(echo notify.desktop)
	eval "$(utils.parse.autosetup)"
	##########################################

	case ${COMMAND} in
		( up )
			pactl set-${DEVICE}-volume ${PACTL_DEVICE} +10% \
				|| notify.error "pactl error with set-${DEVICE}-volume"

			media.audio.play-sfx volume
			;;

		( down )
			pactl set-${DEVICE}-volume ${PACTL_DEVICE} -10% \
				|| notify.error "pactl error with set-${DEVICE}-volume"

			media.audio.play-sfx volume
			;;

		( mute )
			pactl set-${DEVICE}-mute ${PACTL_DEVICE} toggle \
				&& notify.success "default ${DEVICE}" "$(amixer sget ${AMIXER_DEVICE} | grep -q '\[on\]' && echo unmuted || echo muted)" \
				|| notify.error   "pactl error with set-${DEVICE}-mute"

			media.audio.play-sfx mute
			;;
	esac

	return ${ERRORS}
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }
${scwryptsmodule}.parse.locals() {
	local ARGS=()

	local DEVICE
	local AMIXER_DEVICE
	local PACTL_DEVICE
	local COMMAND
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		simplified pactl for volume up/down/mute on default sink and source
	'

	USAGE__args='
		\$1   target device  : one of (sink source)
		\$2   volume command : one of (up down mute)
	'
}

${scwryptsmodule}.parse.validate() {
	DEVICE="${ARGS[1]}"
	[ "${DEVICE}" ] \
		|| notify.error 'missing device'

	COMMAND="${ARGS[2]}"
	[ "${COMMAND}" ] \
		|| notify.error 'missing command'

	[ "${DEVICE}" ] && [ "${COMMAND}" ] || return

	case ${DEVICE} in
		( sink   ) AMIXER_DEVICE=Master  ;;
		( source ) AMIXER_DEVICE=Capture ;;
		( * )
			notify.error "unsupported device '${DEVICE}'"
			;;
	esac

	case ${COMMAND} in
		( up | down | mute ) ;;
		( * )
			notify.error "unsupported command '${COMMAND}'"
			;;
	esac

	PACTL_DEVICE="@DEFAULT_$(echo ${DEVICE} | tr '[:lower:]' '[:upper:]')@"
}
