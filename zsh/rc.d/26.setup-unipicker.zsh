command -v unipicker &>/dev/null || return 0
#####################################################################

__ZSH_SHORTCUT__UNIPICKER() {
	LBUFFER+="$(unipicker)"
	zle reset-prompt
}

zle -N unipicker __ZSH_SHORTCUT__UNIPICKER
bindkey  unipicker

#####################################################################
return 0
