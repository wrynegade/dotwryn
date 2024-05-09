#
# configuration for scwrypts
#

SCWRYPTS_SHORTCUT=''     # CTRL + W
SCWRYPTS_ENV_SHORTCUT='' # CTRL + /

for SEARCH_DIR in \
	"$HOME/.wryn/scwrypts" \
	"$HOME/Projects/yage/" \
	;
do
	[ -d "$SEARCH_DIR" ] || continue
	for G in "$SEARCH_DIR/"**/*.scwrypts.zsh; do . "$G"; done
done

[ -f "$HOME/.config/scwrypts/config.local.zsh" ] \
	&& source "$HOME/.config/scwrypts/config.local.zsh" 
