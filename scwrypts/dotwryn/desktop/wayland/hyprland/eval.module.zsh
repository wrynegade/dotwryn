#####################################################################

DEPENDENCIES+=(hyprctl)

#####################################################################

${scwryptsmodule}() {
	eval "$(utils.parse.autosetup)"
	##########################################

	local result="$(hyprctl eval "$(printf '%s\n' "${ARGS[@]}")")"

	[[ "${result}" == ok ]] \
		|| echo.error "hyprctl eval failed : ${result}" \
		|| return 1
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }

${scwryptsmodule}.parse.locals() {
	local ARGS=()
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		run hyprland lua in the current hyprland instance (one statement per
		argument, evaluated together); fails unless hyprland replies "ok"
	'

	USAGE__args='
		\$@   lua statements (e.g. "hl.dispatch(hl.dsp.window.center({}))")
	'
}

${scwryptsmodule}.parse.validate() {
	[[ "${#ARGS[@]}" -gt 0 ]] \
		|| echo.error 'at least one lua statement is required'
}
