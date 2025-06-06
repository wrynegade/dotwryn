_COLORSCHEME_FILE__alacritty="${DOTWRYN}/config/user/alacritty/theme.toml"

_GENERATE_THEME__alacritty() {
	echo "# do not edit; generated by scwrypts
# theme : ${THEME_NAME}
[colors.cursor]
cursor = '0x$(_GET_HEX .alacritty.cursor cursor)'

[colors.primary]
background = '0x$(_GET_HEX .alacritty.background .background)'
foreground = '0x$(_GET_HEX .alacritty.foreground .foreground)'

[colors.normal]
black   = '0x$(_GET_HEX .ansi.gray.black)'
red     = '0x$(_GET_HEX .ansi.red.regular)'
green   = '0x$(_GET_HEX .ansi.green.regular)'
yellow  = '0x$(_GET_HEX .ansi.yellow.regular)'
blue    = '0x$(_GET_HEX .ansi.blue.regular)'
magenta = '0x$(_GET_HEX .ansi.magenta.regular)'
cyan    = '0x$(_GET_HEX .ansi.cyan.regular)'
white   = '0x$(_GET_HEX .ansi.gray.white)'

[colors.bright]
black   = '0x$(_GET_HEX .ansi.gray.regular)'
red     = '0x$(_GET_HEX .ansi.red.bright)'
green   = '0x$(_GET_HEX .ansi.green.bright)'
yellow  = '0x$(_GET_HEX .ansi.yellow.bright)'
blue    = '0x$(_GET_HEX .ansi.blue.bright)'
magenta = '0x$(_GET_HEX .ansi.magenta.bright)'
cyan    = '0x$(_GET_HEX .ansi.cyan.bright)'
white   = '0x$(_GET_HEX .ansi.gray.bright)'
" | sed '$d' > "${_COLORSCHEME_FILE__alacritty}"

	local TRANSPARENCY_OVERRIDE=$(cat "${SOURCE_THEME}" | utils.yq -r '.alacritty.transparency' | grep -v '^null$')
	[ ${TRANSPARENCY_OVERRIDE} ] && {
		printf "[window]\nopacity = ${TRANSPARENCY_OVERRIDE}\n" >> "${_COLORSCHEME_FILE__alacritty}"
	}

	return 0
}

_SET_THEME__alacritty() {
	return 0  # theme is referenced explicitly after generation
}
