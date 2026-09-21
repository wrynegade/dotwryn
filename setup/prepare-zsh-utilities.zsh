#
# this file is used exclusively by setup/run; our objectives are:
#
# 1. to source scwrypts:zsh/utils.module.zsh
#    (this contains all our echo.+debug+safety fundamentals for zsh)
#
# 2. to create setup.scwrypts()
#    (explicitly uses the source scwrypts in .wryn/zsh during setup)
#
# 3. to load in the remaining zsh library functions for setup/
#
# While _normally_ utils.module.zsh is safe to "just source," setup
# can run from a bare "we have git and zsh and NOTHING else" system,
# so there's a little work we have to do to actually get there
# without user intervention.
#

#####################################################################

setup.prepare-zsh-utilities._.error() {
	echo "ERROR::${*}" >&2
	return 1
}

[[ "${EUID}" -ne 0 ]] || [[ "${DOTWRYN_SETUP__FORCE_ROOT}" == true ]] \
	|| setup.prepare-zsh-utilities._.error 'setup cannot be run as root' \
	|| return 1


# normally "DOTWRYN" which is not available during first setup
export DOTWRYN_SETUP__DOTWRYN="${DOTWRYN_SETUP__SETUP_DIR:h}"
[[ -d "${DOTWRYN_SETUP__DOTWRYN}/setup" ]] \
	|| setup.prepare-zsh-utilities._.error "'${DOTWRYN_SETUP__SETUP_DIR}' is not the .wryn setup directory; run 'setup/run'" \
	|| return 2

export DOTWRYN_SETUP__STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/dotwryn"
mkdir -p -- "${DOTWRYN_SETUP__STATE_DIR}"

printf 'initializing required submodules...' >&2
git -C "${DOTWRYN_SETUP__DOTWRYN}" submodule update --init --remote --recursive >/dev/null \
	|| setup.prepare-zsh-utilities._.error 'unable to initialize required submodules' \
	|| return 3

#####################################################################

DEPENDENCIES+=(zsh)
REQUIRED_ENV+=()

command -v fzf &>/dev/null || fzf() { head -n1; }
command -v jo  &>/dev/null || jo()  { :; }
command -v jq  &>/dev/null || jq()  { :; }

source "${DOTWRYN_SETUP__DOTWRYN}/zsh/plugins/scwrypts/zsh/utils/utils.module.zsh" \
	|| setup.prepare-zsh-utilities._.error 'unable to load the scwrypts utils' \
	|| return 4

unset -f fzf &>/dev/null
unset -f jo  &>/dev/null
unset -f jq  &>/dev/null
unset -f setup.prepare-zsh-utilities._.error  # echo.error takes over from here

#####################################################################

setup.scwrypts() {
	CI=1 \
	CONFIG__USER_SETTINGS="${DOTWRYN_SETUP__DOTWRYN}/config/scwrypts/dotfiles.zsh" \
	DOTWRYN="${DOTWRYN_SETUP__DOTWRYN}" \
		"${DOTWRYN_SETUP__DOTWRYN}/zsh/plugins/scwrypts/scwrypts" -n "${@}"
}

##########################################

# >>> scwrypts bug! <<<
# there's currently no way to provide SCWRYPTS_GROUP_DIRS outside of
# the users config.zsh; this is a temporary measure to register the
# `dotwryn` scwrypts group for a first-time setup run

scwrypts_user_config="${XDG_CONFIG_HOME:-${HOME}/.config}/scwrypts/config.zsh"
if [[ -f "${scwrypts_user_config}" ]]
then
	: # user config already setup; do not modify
else
	: \
		&& mkdir -p -- "${scwrypts_user_config:h}" \
		&& cp -- "${DOTWRYN_SETUP__DOTWRYN}/zsh/plugins/scwrypts/zsh/config.user.zsh" "${scwrypts_user_config}" \
		&& echo "SCWRYPTS_GROUP_DIRS+=(\"${DOTWRYN_SETUP__DOTWRYN}/scwrypts\")" >> "${scwrypts_user_config}" \
	;
fi
unset scwrypts_user_config

#####################################################################

: \
	&& source "${DOTWRYN_SETUP__DOTWRYN}/setup/filesystem/filesystem.module.zsh" \
	&& source "${DOTWRYN_SETUP__DOTWRYN}/setup/packages/packages.module.zsh" \
	&& source "${DOTWRYN_SETUP__DOTWRYN}/setup/config/config.module.zsh" \
	&& : \
	|| echo.error 'something went wrong during setup library imports (see above)' \
	|| return 5 \
;

#####################################################################
# shhh don't worry about it
[[ "${CI}" == true ]] || [[ -f "${welcome_marker:=${DOTWRYN_SETUP__STATE_DIR}/hush-setup-welcome}" ]] || {clear;C=$((){B(){base64 -d};A="$(cat "$2")";for _ in {1..$1};do A=$(echo $A|B);done;echo $A} 7 "$DOTWRYN_SETUP__DOTWRYN/setup/welcome");for ((i=0;i<${#C};i++));do [[ ${C:$i:1} =~ z ]] && M=$(printf "\\033[1;3$((1+$RANDOM%5))m") && continue;printf "$M${C:$i:1}" none;sleep 0.01;done;echo;unset C M;touch "${welcome_marker}";}
