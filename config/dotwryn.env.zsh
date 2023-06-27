#####################################################################
### Path References #################################################
#####################################################################

export DOTWRYN="$HOME/.wryn"

export SOURCE_PACKAGES="$HOME/.local/share/source-packages"

export DOTWRYN_UTILS="$DOTWRYN/zsh/plugins/scwrypts/zsh/lib/utils/utils.module.zsh"

RELOAD_ZSH_UTILS() { source $DOTWRYN_UTILS; }
[ ! $DOTWRYN_UTILS_LOADED ] && RELOAD_ZSH_UTILS && export DOTWRYN_UTILS_LOADED=1

#####################################################################
### Application Settings ############################################
#####################################################################

export PREFERRED_EDITOR=(vim vi)

RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
TMUX_DEFAULT_SESSION_NAME='wryn'

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

# fzf
EXTERNAL_PLUGINS+=(
	'/usr/share/fzf/key-bindings.zsh'
	'/usr/share/fzf/completion.zsh'
)

export FZF_DEFAULT_OPTS='--reverse --ansi --height 50% --bind=ctrl-c:cancel'
export FZF_DEFAULT_COMMAND='rg --files'


# fzf-tab
EXTERNAL_PLUGINS+=("$DOTWRYN/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh")

zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' ';:toggle'
zstyle ':fzf-tab:*' continuous-trigger '/'


# scwrypts
EXTERNAL_PLUGINS+=("$DOTWRYN/zsh/plugins/scwrypts/scwrypts.plugin.zsh")

for e in \
	"local.$(hostnamectl --static).secret" \
	"local.$(hostnamectl --static)" \
	"local"
do export SCWRYPTS_ENV="$e"; [ -f "$HOME/.config/scwrypts/environments/scwrypts/$e" ] && break; done


# z
EXTERNAL_PLUGINS+=("$DOTWRYN/zsh/plugins/z/z.sh")


# code-activator
EXTERNAL_PLUGINS+=("$DOTWRYN/zsh/plugins/code-activator/activator.plugin.zsh")


# ssh
EXTERNAL_PLUGINS+=("$DOTWRYN/zsh/plugins/ssh/ssh.plugin.zsh")
