[ "$DOTWRYN" ] || {
	[ -d "${HOME}/.wryn" ] \
		&& export DOTWRYN="${HOME}/.wryn" \
		|| export DOTWRYN="${XDG_DATA_HOME:-${HOME}/.local/share}/wryn" \
		;
}

[ "${DOTWRYN}" ] && [ -d "${DOTWRYN}" ] || {
	echo "ERROR : cannot determine \$DOTWRYN location" >&2
	return 1
}

: \
	&& source "${DOTWRYN}/config/dotwryn.env.zsh" \
	&& source "${XDG_CONFIG_HOME:-${HOME}/.config}/wryn/env.zsh" \
	;
