#
# configuration for scwrypts
#

SCWRYPTS_SHORTCUT=''     # CTRL + W

#SCWRYPTS_ENVIRONMENT__SHOW_ENV_HELP=false
#SCWRYPTS_ENVIRONMENT__PREFERRED_EDIT_MODE=quiet

SCWRYPTS_GENERATOR__SHOW_HELP=false

[ ${DOTWRYN} ] || source "${HOME}/.zshrc"
SCWRYPTS_GROUP_DIRS+=("${DOTWRYN}/scwrypts")

[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/scwrypts/config.local.zsh" ] \
	&& source "${XDG_CONFIG_HOME:-${HOME}/.config}/scwrypts/config.local.zsh"
