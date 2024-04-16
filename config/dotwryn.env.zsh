#####################################################################
### Path References #################################################
#####################################################################

export DOTWRYN="$HOME/.wryn"
export SOURCE_PACKAGES="$HOME/.local/share/source-packages"

RELOAD_ZSH_UTILS() {
	local SCWRYPTS_ROOT="$(scwrypts --root 2>/dev/null)"
	: \
		&& [ $SCWRYPTS_ROOT ] \
		&& [ -d "$SCWRYPTS_ROOT" ] \
		&& source "$(scwrypts --root)/zsh/lib/utils/utils.module.zsh" \
		&& export DOTWRYN_UTILS_LOADED=1 \
		;
}
[ $DOTWRYN_UTILS_LOADED ] || RELOAD_ZSH_UTILS

#####################################################################
### Application Settings ############################################
#####################################################################

export PREFERRED_EDITOR=(vim vi)

RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

PS1_BRANCH_SYMBOL=''
PS1_INDICATOR_SYMBOL='☕'
PS1_SEPARATOR='::'
PS1_USER='%m'

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
EXTERNAL_PLUGINS+=("$(scwrypts --root 2>/dev/null)/scwrypts.plugin.zsh")

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
