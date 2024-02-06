#
# configuration for scwrypts
#

SCWRYPTS_SHORTCUT=''     # CTRL + W
SCWRYPTS_ENV_SHORTCUT='' # CTRL + /

source "$HOME/.wryn/scwrypts/dotwryn/dotwryn.scwrypts.zsh"
source "$HOME/.wryn/scwrypts/ssh/ssh.scwrypts.zsh"

[ -f "$HOME/Projects/yage/home/code/scwrypts/yagehome.scwrypts.zsh" ] \
	&& source "$HOME/Projects/yage/home/code/scwrypts/yagehome.scwrypts.zsh"

[ -f "$HOME/.config/scwrypts/config.local.zsh" ] \
	&& source "$HOME/.config/scwrypts/config.local.zsh" 
