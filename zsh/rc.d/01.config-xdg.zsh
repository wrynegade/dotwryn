#####################################################################

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export XDG_RUNTIME_DIR="/run/user/${UID}"

export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

#####################################################################

export AWS_CONFIG_FILE="${XDG_DATA_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_DATA_HOME}/aws/credentials"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GOPATH="${XDG_DATA_HOME}/go"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export KUBECACHEDIR="${XDG_CACHE_HOME}/kube"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"
export MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
export MPLAYER_HOME="${XDG_CONFIG_HOME}/mplayer"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export TERMINFO="${XDG_DATA_HOME}/terminfo"
export TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"
export _Z_DATA="${XDG_DATA_HOME}/z"

#####################################################################

for __SETUP_DIR in \
	"${XDG_STATE_HOME}/zsh" \
	"${XDG_STATE_HOME}/python" \
	"$(dirname -- "${AWS_CONFIG_FILE}")" \
	"$(dirname -- "${NPM_CONFIG_USERCONFIG}")" \
	;
do
	[ -d "${__SETUP_DIR}" ] || mkdir -p -- "${__SETUP_DIR}"
done
unset __SETUP_DIR
