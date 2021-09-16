#####################################################################
### Path References #################################################
#####################################################################

DOTWRYN="$HOME/.wryn"
SFX_PATH="$HOME/Media/sfx"
WALLPAPER_PATH="$HOME/Pictures/bg"

#####################################################################
### Application Settings ############################################
#####################################################################

# ordered from least-preferred to most-preferred
PREFERRED_EDITOR=(vi vim)

# should play an audio file argument
MEDIA_ENGINE='canberra-gtk-play -f'

RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
TMUX_DEFAULT_SESSION_NAME='wryn'
WEBBROWSER='google-chrome-stable'

PS1_BRANCH_SYMBOL=''
PS1_INDICATOR_SYMBOL='☕'
PS1_SEPARATOR='::'
PS1_USER='%n'


#####################################################################
### External Plugins / Settings #####################################
#####################################################################

EXTERNAL_PLUGIN_LIST=(
	"$DOTWRYN/zsh/plugins/z/z.sh"
	'/usr/share/fzf/key-bindings.zsh'
	'/usr/share/fzf/completion.zsh'
	"$DOTWRYN/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
	)

FZF_DEFAULT_OPTS='--reverse'
FZF_DEFAULT_COMMAND='rg --files'

zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' ';:toggle'
zstyle ':fzf-tab:*' continuous-trigger '/'
