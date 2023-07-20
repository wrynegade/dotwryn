#####################################################################

DEPENDENCIES+=(
	awk sed tr
)
REQUIRED_ENV+=()

#####################################################################

GET_COLORSCHEME_HEX() {
	[ $1 ] && [[ $1 -le 15 ]] && [[ $1 -ge 0 ]] \
		|| FAIL 1 'must provide ANSI color number 0-15'

	grep "^color$1 " "$DOTWRYN/colorschemes/kitty.main" \
		| awk '{print $2}' \
		| sed 's/ //g; s/#//g' \
		| tr '[:lower:]' '[:upper:]' \
		;
}

SET_THEME() {
	local THEME="$DOTWRYN/colorschemes/kitty.$1"
	[ ! -f "$THEME" ] && FAIL 1 "no such theme '$1'"
	local LOCAL_THEME="$HOME/.config/kitty/theme.conf"
	rm -- $LOCAL_THEME
	ln -s "$THEME" "$LOCAL_THEME"
}
