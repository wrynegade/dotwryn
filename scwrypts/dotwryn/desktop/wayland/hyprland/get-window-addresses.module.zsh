#####################################################################

DEPENDENCIES+=(hyprctl jq)

#####################################################################

${scwryptsmodule}() {
	eval "$(utils.parse.autosetup)"
	##########################################

	hyprctl -j clients \
		| jq -r --arg class "${CLIENT_CLASS}" '.[] | select(.class | test($class; "i")) | .address' \
		;
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }

${scwryptsmodule}.parse.locals() {
	local ARGS=()
	local CLIENT_CLASS
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		print the address of every hyprland window whose class matches
		(one per line; case-insensitive regex)
	'

	USAGE__args='
		\$1   window class regex
	'
}

${scwryptsmodule}.parse.validate() {
	CLIENT_CLASS="${ARGS[1]}"

	[[ "${CLIENT_CLASS}" ]] \
		|| echo.error 'window class is required'
}
