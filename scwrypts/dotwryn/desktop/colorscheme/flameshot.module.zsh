_COLORSCHEME_FILE__flameshot="${DOTWRYN}/config/user/flameshot/flameshot.ini"

_GENERATE_THEME__flameshot() {
	local C1="#$(_GET_HEX .flameshot.color1 .material.primary.200            .ansi.reg.bright )"
	local C2="#$(_GET_HEX .flameshot.color2 .material.primary.500            .ansi.red.regular)"
	local C3="#$(_GET_HEX .flameshot.color3 .material.primary.800            .ansi.green.bright )"
	local C4="#$(_GET_HEX .flameshot.color4 .material.secondary.200          .ansi.green.regular)"
	local C5="#$(_GET_HEX .flameshot.color5 .material.secondary.500          .ansi.blue.bright )"
	local C6="#$(_GET_HEX .flameshot.color6 .material.secondary.800          .ansi.yellow.bright)"
	local C7="#$(_GET_HEX .flameshot.color7 .material.error.500              .ansi.cyan.bright )"
	local C8="#$(_GET_HEX .flameshot.color8 .material.error.200              .ansi.magenta.bright)"
	local C9="#$(_GET_HEX .flameshot.color9 .material.foreground.primary.500 .ansi.gray.bright)"

	local UI_PRIMARY="#$(_GET_HEX   .flameshot.primary   .material.primary.600   .ansi.magenta.bright)"
	local UI_SECONDARY="#$(_GET_HEX .flameshot.secondary .material.secondary.400 .ansi.green.bright)"

	local PICKER="picker, ${C1}, ${C2}, ${C3}, ${C4}, ${C5}, ${C6}, ${C7}, ${C8}, ${C9}"

	sed -i "
		s/^userColors=.*$/userColors=${PICKER}/
		s/^uiColor=.*/uiColor=${UI_PRIMARY}/
		s/^contrastUiColor=.*/contrastUiColor=${UI_SECONDARY}/
	" "${_COLORSCHEME_FILE__flameshot}"
}

_SET_THEME__flameshot() {
	return 0  # theme modifies the config file directly
}
