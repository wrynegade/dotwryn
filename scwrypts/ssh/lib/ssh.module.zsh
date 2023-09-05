#####################################################################

DEPENDENCIES+=(
	ssh
)
REQUIRED_ENV+=()

use connection/parse --group remote

#####################################################################

[ ! $REMOTE_DEFAULT_SHELL ] && REMOTE_DEFAULT_SHELL=(zsh -l)

REMOTE__LOGIN() {
	local READ_COMMAND=0

	[ ! $REMOTE_NAME ] && {
		REMOTE_NAME=$1
		shift 1
	}

	[[ $# -gt 0 ]] && {
		REMOTE_SHELL_ARGS+=(-c "'$@'")
	}

	[ $REMOTE_NAME ] && {
		STATUS "connecting to $REMOTE_NAME"
	}

	PARSE_CONNECTION

	[ ! $REMOTE_HOST ] && {
		ERROR "could not parse REMOTE_HOST from REMOTE_NAME;
			   check the configuration file for errors"
		return 1
	}

	[[ $REMOTE_HOST =~ ^localhost$ ]] && {
		WARNING 'performing login to localhost'
		eval "cd; "${REMOTE_DEFAULT_SHELL[@]} ${REMOTE_SHELL_ARGS[@]}
		return $?
	}

	ssh -t ${REMOTE_ARGS[@]} $REMOTE_HOST "$REMOTE_DEFAULT_SHELL ${REMOTE_SHELL_ARGS[@]} $@"
}
