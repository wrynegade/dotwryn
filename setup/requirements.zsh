[[ $EUID -eq 0 ]] && [ ! $FORCE_ROOT ] \
	&& { echo 'ERROR::Setup cannot be run as root'; exit 1; }

#####################################################################

# normally "DOTWRYN", but uses "DOTWRYN_PATH" to avoid conflict during setup
cd "${0:a:h}"
export DOTWRYN_PATH="$(git rev-parse --show-toplevel)"
cd "$DOTWRYN_PATH"

printf 'initializing required submodules...' >&2
git submodule update --init --remote --recursive >/dev/null 2>&1 || {
	echo 'failed!' >&2
	echo 'unable to initialize required submodules' >&2
	exit 2
}

#####################################################################

_DEPENDENCIES+=(zsh)
_REQUIRED_ENV+=()

command -v fzf &>/dev/null || fzf() { head -n1; }

source "$DOTWRYN_PATH ../zsh/plugins/scwrypts/zsh/lib/utils/utils.module.zsh" || exit 3

unset -f fzf &>/dev/null

SCWRYPTS() {
	CI=1 \
	CONFIG__USER_SETTINGS="$DOTWRYN_PATH/config/scwrypts/dotfiles.zsh" \
	DOTWRYN=$DOTWRYN_PATH \
		"$DOTWRYN_PATH/zsh/plugins/scwrypts/scwrypts" -n $@
}

#####################################################################

source "$DOTWRYN_PATH/setup/os.zsh"
source "$DOTWRYN_PATH/setup/git.zsh"
source "$DOTWRYN_PATH/setup/config.zsh"

#####################################################################
clear

# shhh don't worry about it
[[ $CI -ne 0 ]] || {C=$((){B(){base64 -d};A="$(cat "$2")";for _ in {1..$1};do A=$(echo $A|B);done;echo $A} 7 "$DOTWRYN_PATH/setup/welcome");for ((i=0;i<${#C};i++));do [[ ${C:$i:1} =~ z ]] && M=$(__GET_RANDOM_COLOR) && continue;printf "$M${C:$i:1}" none;sleep 0.01;done;echo;unset C M;}
