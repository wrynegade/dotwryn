#####################################################################

use notify
use scwrypts/get-realpath

DEPENDENCIES+=(canberra-gtk-play)
REQUIRED_ENV+=(DESKTOP__SFX_PATH)

#####################################################################

${scwryptsmodule}() {
	local SCWRYPTS_NOTIFICATION_ENGINES=(echo notify.desktop)

	eval "$(utils.parse.autosetup)"

	##########################################

	echo.status 'starting playback'
	canberra-gtk-play -f "${SFX_FILE}" \
		&& echo.success "finished output of '${SFX_FILE}'" \
		|| notify.error "something went wrong playing file '${SFX_FILE}'" \
		|| return 1
}

#####################################################################

${scwryptsmodule}.parse() {
	[[ ${POSITIONAL_ARGS} -eq 0 ]] || return 0

	((POSITIONAL_ARGS+=1))
	case $1 in
		( backlight ) SFX_FILE="${DESKTOP__SFX_PATH}/yaru-audio-volume-change.oga" ;;
		( gamedock  ) SFX_FILE="${DESKTOP__SFX_PATH}/gamedock.oga"                 ;;
		( homedock  ) SFX_FILE="${DESKTOP__SFX_PATH}/homedock.oga"                 ;;
		( login     ) SFX_FILE="${DESKTOP__SFX_PATH}/yaru-desktop-login.oga"       ;;
		( logout    ) SFX_FILE="${DESKTOP__SFX_PATH}/smooth-desktop-login.oga"     ;;
		( mute      ) SFX_FILE="${DESKTOP__SFX_PATH}/smooth-dialog-warning.oga"    ;;
		( notify    ) SFX_FILE="${DESKTOP__SFX_PATH}/yaru-complete.oga"            ;;
		( undock    ) SFX_FILE="${DESKTOP__SFX_PATH}/yaru-desktop-login.oga"       ;;
		( volume    ) SFX_FILE="${DESKTOP__SFX_PATH}/yaru-message.oga"             ;;

		( * )
			SFX_FILE="$1"
			;;
	esac

	return 1
}

${scwryptsmodule}.parse.locals() {
	local SFX_FILE
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		play the indicated sound effect by mapped name or filename

		mapped names :
		  backlight  notify
		  login      logout
		  mute       volume
		  gamedock   homedock  undock
	'

	USAGE__args='
		\$1   mapped name or filename
	'
}

${scwryptsmodule}.parse.validate() {
	[ -f "$(scwrypts.get-realpath "${SFX_FILE}")" ] \
		&& SFX_FILE="$(scwrypts.get-realpath "${SFX_FILE}")" \
		|| SFX_FILE="${DESKTOP__SFX_PATH}/${SFX_FILE}" \
		;

	[ -f "${SFX_FILE}" ] \
		|| notify.error "unable to locate sfx file '$1'" \
		|| return 1
}
