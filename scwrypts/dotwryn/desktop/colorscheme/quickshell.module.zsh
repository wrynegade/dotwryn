_COLORSCHEME_FILE__quickshell="${DOTWRYN}/config/user/quickshell/colors.json"

_GENERATE_THEME__quickshell() {
	echo "{
	\"theme\"         : \"${THEME_NAME}\",
	\"background\"    : \"#$(_GET_HEX .quickshell.background     .background)\",
	\"foreground\"    : \"#$(_GET_HEX .quickshell.foreground     .foreground)\",
	\"backgroundAlt\" : \"#$(_GET_HEX .quickshell.background-alt .selection.background)\",
	\"foregroundAlt\" : \"#$(_GET_HEX .quickshell.foreground-alt .selection.foreground)\",
	\"primary\"       : \"#$(_GET_HEX .quickshell.primary        .material.base.primary   .ansi.yellow.regular)\",
	\"secondary\"     : \"#$(_GET_HEX .quickshell.secondary      .material.base.secondary .ansi.green.regular)\",
	\"alert\"         : \"#$(_GET_HEX .quickshell.alert          .material.base.error     .ansi.red.regular)\",
	\"disabled\"      : \"#$(_GET_HEX .quickshell.disabled       .ansi.gray.regular)\",

	\"secondaryGradient\" : [
		\"#$(_GET_HEX .quickshell.secondary-gradient-0 .material.secondary.700 .ansi.green.regular)\",
		\"#$(_GET_HEX .quickshell.secondary-gradient-1 .material.secondary.600 .ansi.green.regular)\",
		\"#$(_GET_HEX .quickshell.secondary-gradient-2 .material.secondary.500 .ansi.green.regular)\",
		\"#$(_GET_HEX .quickshell.secondary-gradient-3 .material.secondary.400 .ansi.green.regular)\",
		\"#$(_GET_HEX .quickshell.secondary-gradient-4 .material.secondary.300 .ansi.green.regular)\"
	]
}" > "${_COLORSCHEME_FILE__quickshell}"
}

_SET_THEME__quickshell() {
	return 0  # quickshell watches colors.json and reloads on change
}
