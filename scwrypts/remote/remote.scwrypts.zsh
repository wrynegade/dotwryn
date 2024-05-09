SCWRYPTS_GROUPS+=(remote)
[ $DOTWRYN ] || source "$HOME/.config/wryn/env.zsh"

export SCWRYPTS_TYPE__remote=zsh
export SCWRYPTS_ROOT__remote="$DOTWRYN/scwrypts/remote"
export SCWRYPTS_COLOR__remote='\033[0;34m'

DEPENDENCIES+=(yq)
REMOTE_CONNECTIONS_FILE="$HOME/.config/wryn/remote-connections.toml"

SCWRYPTS__LIST_AVAILABLE_SCWRYPTS__remote() {
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
	} | sed "s|^|$SCWRYPTS_TYPE__remote/|"
}

SCWRYPTS__GET_RUNSTRING__remote__zsh() {
	local SCWRYPT_FILENAME
	case $SCWRYPT_NAME in
		connect/* ) 
			SCWRYPT_FILENAME="$SCWRYPTS_ROOT__remote/connect"
			echo "export REMOTE__TARGET=$(echo $SCWRYPT_NAME | sed 's|^.*connect/||')"
			;;
		* )
			SCWRYPT_FILENAME="$SCWRYPTS_ROOT__remote/$SCWRYPT_NAME"
			;;
	esac

	SCWRYPTS__GET_RUNSTRING__zsh__generic "$SCWRYPT_FILENAME"
}
