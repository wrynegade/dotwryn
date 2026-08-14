#####################################################################

use notify
use scwrypts/get-realpath

DEPENDENCIES+=(canberra-gtk-play)
REQUIRED_ENV+=(DESKTOP__SFX_PATH)

#####################################################################

${scwryptsmodule}() {
	local SCWRYPTS_NOTIFICATION_ENGINES=(echo notify.desktop)
	local DESCRIPTION='plays a sound effect'

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

	# mapped names live in $DOTWRYN/config/sfx.map (shared with the hyprland quickshell)
	local mapped_file="$(awk -v name="${1}" '!/^#/ && $1 == name { print $2; exit }' "${DOTWRYN}/config/sfx.map" 2>/dev/null)"

	[[ "${mapped_file}" ]] \
		&& SFX_FILE="${DESKTOP__SFX_PATH}/${mapped_file}" \
		|| SFX_FILE="${1}" \
		;

	return 1
}

${scwryptsmodule}.parse.locals() {
	local SFX_FILE
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		play the indicated sound effect by mapped name or filename
	'

	USAGE__args='
		\$1   mapped name or filename

		mapped names :
		  backlight  notify
		  login      logout
		  mute       volume
		  gamedock   homedock  undock
	'
}

${scwryptsmodule}.parse.validate() {
	[ -f "$(scwrypts.get-realpath "${SFX_FILE}")" ] \
		&& SFX_FILE="$(scwrypts.get-realpath "${SFX_FILE}")" \
		|| SFX_FILE="${DESKTOP__SFX_PATH}/${SFX_FILE}" \
		;

	[ -f "${SFX_FILE}" ] \
		|| notify.error "unable to locate sfx file '${SFX_FILE}'" \
		|| return 1
}
