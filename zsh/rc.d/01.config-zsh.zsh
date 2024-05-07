#####################################################################

HISTFILE=~/.local/zsh.history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory autocd beep notify HIST_IGNORE_SPACE
unsetopt nomatch

bindkey -v
bindkey '^R' history-incremental-search-backward

# ESC,v to use $EDITOR to modify the current command
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# zsh auto/tab-completion engine
zmodload -i zsh/complist
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select
bindkey -M menuselect '^M' .accept-line

#####################################################################
return 0
