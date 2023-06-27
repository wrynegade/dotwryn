#
# configuration for scwrypts
#

SCWRYPTS_SHORTCUT=''     # CTRL + W
SCWRYPTS_ENV_SHORTCUT='' # CTRL + /

source "$HOME/.wryn/scwrypts/dotwryn.scwrypts.zsh"

[ -f "$HOME/.config/scwrypts/config.local.zsh" ] \
	&& source "$HOME/.config/scwrypts/config.local.zsh" 
