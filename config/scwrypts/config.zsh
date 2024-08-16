#
# configuration for scwrypts
#

SCWRYPTS_SHORTCUT=''     # CTRL + W
SCWRYPTS_ENV_SHORTCUT='' # CTRL + /

SCWRYPTS_ENVIRONMENT__SHOW_ENV_HELP=false
SCWRYPTS_ENVIRONMENT__PREFERRED_EDIT_MODE=quiet

for SEARCH_DIR in \
	"$DOTWRYN/scwrypts" \
	"$HOME/Projects/yage/" \
	;
do
	[ -d "$SEARCH_DIR" ] || continue
	for G in "$SEARCH_DIR/"**/*.scwrypts.zsh; do . "$G"; done
done

[ -f "$HOME/.config/scwrypts/config.local.zsh" ] \
	&& source "$HOME/.config/scwrypts/config.local.zsh" 
