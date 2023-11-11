SCWRYPTS_GROUPS+=(remote)
[ $DOTWRYN ] || source "$HOME/.config/wryn/env.zsh"

export SCWRYPTS_TYPE__remote=zsh
export SCWRYPTS_ROOT__remote="$DOTWRYN/scwrypts/ssh"
export SCWRYPTS_COLOR__remote='\033[0;34m'

REMOTE_CONNECTIONS_FILE="$HOME/.config/wryn/remote-connections"

SCWRYPTS__LIST_AVAILABLE_SCWRYPTS__remote() {
	[ ! -f "$REMOTE_CONNECTIONS_FILE" ] && {
		[ -f "$HOME/.config/wryn/ssh-connections" ] \
			&& cp "$HOME/.config/wryn/ssh-connections" "$REMOTE_CONNECTIONS_FILE" \
			|| touch "$REMOTE_CONNECTIONS_FILE"
	}

	for CONNECTION_TYPE in $(cd $SCWRYPTS_ROOT__remote/connect; find . -mindepth 1 -type f -executable)
	do
		CONNECTION_TYPE="$(echo $CONNECTION_TYPE | sed 's/\.\///;')"
		(
			echo "0 | $(hostnamectl --static) | localhost"
			echo '0 | localhost | localhost'
			cat "$REMOTE_CONNECTIONS_FILE"
		) | sed -n 's/#.*//; /./p' | awk '{print $3;}' | sort -u | sed "s|^|$SCWRYPTS_TYPE__remote/connect/$CONNECTION_TYPE/|"
	done

	echo "$SCWRYPTS_TYPE__remote/tmux/omni"
	echo "$SCWRYPTS_TYPE__remote/tmux/spawn"
	echo "$SCWRYPTS_TYPE__remote/remote/configure"
}

SCWRYPTS__GET_RUNSTRING__remote__$SCWRYPTS_TYPE__remote() {
	[[ $SCWRYPT_NAME =~ tmux/omni ]] \
		&& echo "source $SCWRYPTS_ROOT__remote/omni/launcher" \
		&& return 0

	[[ $SCWRYPT_NAME =~ tmux/spawn ]] \
		&& echo "source $SCWRYPTS_ROOT__remote/omni/spawn" \
		&& return 0

	[[ $SCWRYPT_NAME =~ remote/configure ]] \
		&& echo "EDIT $REMOTE_CONNECTIONS_FILE" \
		&& return 0

	local DETAILS=$(echo $SCWRYPT_NAME | sed 's|connect||; s|/| |g;')

	local CONNECTION_TYPE=$(echo $DETAILS | awk '{print $1;}')
	local TARGET=$(echo $DETAILS | awk '{print $2;}')

	echo "source $SCWRYPTS_ROOT__remote/connect/$CONNECTION_TYPE $TARGET"
}
