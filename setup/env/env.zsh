#####################################################################
### Path References #################################################
#####################################################################

DOTWRYN="$HOME/.wryn"
SFX_PATH="$HOME/Media/sfx"
WALLPAPER_PATH="$HOME/Pictures/bg"

#####################################################################
### Application Settings ############################################
#####################################################################

PREFERRED_EDITOR=(vim vi)

# should play an audio file argument
MEDIA_ENGINE='canberra-gtk-play -f'
PLAY_SFX () { $DOTWRYN/bin/play-sound $@ >/dev/null 2>&1; }

RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
TMUX_DEFAULT_SESSION_NAME='wryn'
WEBBROWSER='google-chrome-stable'

#I3__GLOBAL_FONT_SIZE=
#I3__DMENU_FONT_SIZE=
#I3__BORDER_PIXEL_SIZE=

DOTWRYN_AWS_PROFILE='yage'
DOTWRYN_AWS_REGION='us-east-2'
DOTWRYN_AWS_OUTPUT='json'

S3_SYNC_AWS_PROFILE=$DOTWRYN_AWS_PROFILE
S3_SYNC_BUCKET='yage'
S3_SYNC_MEDIA=(
	#'.local/share/dolphin-emu'
	#'Documents'
	#'Games/roms'
	#'Games/wrynscape'
	'.porn'
	'Documents'
	'Media'
	'Pictures'
	)


PS1_BRANCH_SYMBOL=''
PS1_INDICATOR_SYMBOL='☕'
PS1_SEPARATOR='::'
PS1_USER='%n'

WELCOME () {
	{ figlet 'Welcome, beautiful'; cowsay -p 'damn u sexy'; } | lolcat
}

#####################################################################
### External Plugins / Settings #####################################
#####################################################################

EXTERNAL_PLUGINS=(
	'/usr/share/fzf/key-bindings.zsh'
	'/usr/share/fzf/completion.zsh'
	"$DOTWRYN/zsh/plugins/z/z.sh"
	"$DOTWRYN/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
	"$DOTWRYN/zsh/plugins/code-activator/activator.plugin.zsh"
	"$DOTWRYN/zsh/plugins/scwrypts/scwrypts.plugin.zsh"
	"$DOTWRYN/zsh/plugins/ssh/ssh.plugin.zsh"
	)

FZF_DEFAULT_OPTS='--reverse'
FZF_DEFAULT_COMMAND='rg --files'

zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' ';:toggle'
zstyle ':fzf-tab:*' continuous-trigger '/'

export ZSH_COLOR_UTIL="$DOTWRYN/zsh/plugins/color/color.module.zsh"
