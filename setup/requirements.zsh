[[ $EUID -eq 0 ]] && { echo 'ERROR::Setup cannot be run as root'; exit 1; }

#####################################################################

#printf 'initializing required submodules...' >&2
#git submodule update --init --remote --recursive >/dev/null 2>&1 || {
#	echo 'failed!' >&2
#	echo 'unable to initialize required submodules' >&2
#	exit 2
#}

#####################################################################

# normally "DOTWRYN", but uses "DOTWRYN_PATH" to avoid conflict during setup
cd "${0:a:h}"
export DOTWRYN_PATH="$(git rev-parse --show-toplevel)"
cd "$DOTWRYN_PATH"

#####################################################################

_DEPENDENCIES+=(zsh fzf)
_REQUIRED_ENV+=()
source "$DOTWRYN_PATH/zsh/plugins/scwrypts/zsh/utils/utils.module.zsh" || exit 3

SCWRYPTS() { CI=1 "$DOTWRYN_PATH/zsh/plugins/scwrypts/scwrypts" -n $1 -- ${@:2}; }

#####################################################################

source "$DOTWRYN_PATH/setup/os.zsh"
source "$DOTWRYN_PATH/setup/config.zsh"

#####################################################################
clear
