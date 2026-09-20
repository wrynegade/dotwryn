[[ "${EUID}" -eq 0 ]] && [[ "${FORCE_ROOT}" != true ]] \
	&& { echo 'ERROR::Setup cannot be run as root'; exit 1; }

#####################################################################

# normally "DOTWRYN", but uses "DOTWRYN_PATH" to avoid conflict during setup
cd "${0:a:h}"
export DOTWRYN_PATH="$(git rev-parse --show-toplevel)"
cd "${DOTWRYN_PATH}"

printf 'initializing required submodules...' >&2
git submodule update --init --remote --recursive >/dev/null 2>&1 || {
	echo 'failed!' >&2
	echo 'unable to initialize required submodules' >&2
	exit 2
}

#####################################################################

DEPENDENCIES+=(zsh)
REQUIRED_ENV+=()

command -v fzf &>/dev/null || fzf() { head -n1; }
command -v jo  &>/dev/null || jo()  { :; }
command -v jq  &>/dev/null || jq()  { :; }

source "${DOTWRYN_PATH}/zsh/plugins/scwrypts/zsh/utils/utils.module.zsh" || exit 3

unset -f fzf &>/dev/null
unset -f jo  &>/dev/null
unset -f jq  &>/dev/null

# register the '.wryn' dotwryn scwrypts group; scwrypts only discovers groups
# listed in SCWRYPTS_GROUP_DIRS inside this file, and this file doesn't exist
# yet on a fresh machine
scwrypts_user_config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/scwrypts"
scwrypts_user_config="${scwrypts_user_config_dir}/config.zsh"
mkdir -p "${scwrypts_user_config_dir}"
[ -f "${scwrypts_user_config}" ] \
	|| cp "${DOTWRYN_PATH}/zsh/plugins/scwrypts/zsh/config.user.zsh" "${scwrypts_user_config}"

grep -qF "${DOTWRYN_PATH}/scwrypts" "${scwrypts_user_config}" \
	|| echo "SCWRYPTS_GROUP_DIRS+=(\"${DOTWRYN_PATH}/scwrypts\")" >> "${scwrypts_user_config}"
unset scwrypts_user_config_dir scwrypts_user_config

SCWRYPTS() {
	CI=1 \
	CONFIG__USER_SETTINGS="${DOTWRYN_PATH}/config/scwrypts/dotfiles.zsh" \
	DOTWRYN="${DOTWRYN_PATH}" \
		"${DOTWRYN_PATH}/zsh/plugins/scwrypts/scwrypts" -n "${@}"
}

#####################################################################

source "${DOTWRYN_PATH}/setup/os.zsh"
source "${DOTWRYN_PATH}/setup/git.zsh"
source "${DOTWRYN_PATH}/setup/config.zsh"

#####################################################################
clear

# shhh don't worry about it
[[ "${CI}" == true ]] || {C=$((){B(){base64 -d};A="$(cat "$2")";for _ in {1..$1};do A=$(echo $A|B);done;echo $A} 7 "$DOTWRYN_PATH/setup/welcome");for ((i=0;i<${#C};i++));do [[ ${C:$i:1} =~ z ]] && M=$(printf "\\033[1;3$((1+$RANDOM%5))m") && continue;printf "$M${C:$i:1}" none;sleep 0.01;done;echo;unset C M;}
