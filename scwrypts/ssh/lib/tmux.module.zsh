#####################################################################

DEPENDENCIES+=(
	tmux
)
REQUIRED_ENV+=()

use ssh --group remote

#####################################################################

REMOTE_CONNECT_TMUX() {
	local REMOTE_NAME="$1"
	local USAGE="
		usage: REMOTE_NAME
		Connect to remote tmux session on '$REMOTE_NAME'
		"
	
	local REMOTE_HOST
	local REMOTE_ARGS=()

	IS_VALID_CONNECTION_NAME $REMOTE_NAME || ERROR "invalid REMOTE_NAME '$REMOTE_NAME'"

	CHECK_ERRORS

	local TMUX_ARGS=()

	# enforce UTF-8 if supported by host locale
	TMUX_ARGS+=($(locale charmap | grep -q 'UTF-8' && echo '-u'))

	# create or connect to session
	TMUX_ARGS+=(new-session -As wryn)

	REMOTE__LOGIN "tmux ${TMUX_ARGS[@]}"
}

