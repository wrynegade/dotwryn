#####################################################################

OMNI_SOCKET="omni.socket"

OMNI_LOGDIR="${XDG_STATE_HOME:-${HOME}/.local/state}/wryn/omni"
mkdir -p "${OMNI_LOGDIR}"

${scwryptsmodule}.tmux() {
	tmux -L ${OMNI_SOCKET} $@
}


#####################################################################
