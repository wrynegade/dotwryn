#####################################################################

command -v op >/dev/null 2>&1 && {
	eval "$(op completion zsh)"
	compdef _op op
	export OP_FORMAT=json
}

command -v flux >/dev/null 2>&1 && {
	. <(flux completion zsh)
}

#####################################################################
return 0
