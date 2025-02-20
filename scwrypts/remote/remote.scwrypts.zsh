readonly ${scwryptsgroup}__type=zsh
readonly ${scwryptsgroup}__color=$(utils.colors.blue)

#####################################################################

DEPENDENCIES+=(yq)
REMOTE_CONNECTIONS_FILE="${XDG_CONFIG_HOME:-${HOME}/.config}/wryn/remote-connections.toml"

${scwryptsgroup}.list-available() {
	[ -f "$REMOTE_CONNECTIONS_FILE" ] || {
		mkdir -p "$(dirname -- "$REMOTE_CONNECTIONS_FILE")" &>/dev/null
		echo "
			[sessions]

			[sessions.$(hostnamectl --static)]
			enabled = true
			host = 'localhost'
			" | sed 's/^\s\+//; 1d; $d;' > "$REMOTE_CONNECTIONS_FILE"
	}

	{
		yq -oy -r '.sessions | keys | .[]' "$REMOTE_CONNECTIONS_FILE" \
			| sed 's|^|connect/|'

		echo "tmux/omni"
		echo "configure"
		echo "test"
	} | sed "s|^|zsh/|"
}

${scwryptsgroup}.zsh.get-runstring() {
	local SCWRYPT_FILENAME
	case $SCWRYPT_NAME in
		connect/* )
			SCWRYPT_FILENAME="$(scwrypts.config.group remote root)/connect"
			echo "export REMOTE__TARGET=$(echo $SCWRYPT_NAME | sed 's|^.*connect/||')"
			;;
		* )
			SCWRYPT_FILENAME="$(scwrypts.config.group remote root)/$SCWRYPT_NAME"
			;;
	esac

	scwrypts.get-runstring.zsh.generic
}

remote.config.yq() {
	utils.yq -oy -r $@ "${REMOTE_CONNECTIONS_FILE}" \
		| grep -v ^null$
}
