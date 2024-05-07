#####################################################################

ZSH_PLUGINS+=(
	'/usr/share/fzf/key-bindings.zsh'
	'/usr/share/fzf/completion.zsh'
	"$DOTWRYN/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
)

export FZF_DEFAULT_OPTS='--reverse --ansi --height 50% --bind=ctrl-c:cancel'
export FZF_DEFAULT_COMMAND='rg --files'

zstyle ':fzf-tab:*' accept-line enter
zstyle ':fzf-tab:*' fzf-bindings 'space:accept' ';:toggle'
zstyle ':fzf-tab:*' continuous-trigger '/'

#####################################################################
return 0
