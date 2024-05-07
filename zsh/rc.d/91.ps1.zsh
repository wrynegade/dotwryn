#####################################################################

PS1__GET_DIRECTORY() {
	local _DIRECTORY="%B%F{yellow}%6~"
	local GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
	[ $GIT_ROOT ] && {
		local PROJECT_NAME=$(basename $GIT_ROOT)
		[[ $PROJECT_NAME =~ ^code$ ]] && PROJECT_NAME=$(basename $(dirname $GIT_ROOT))

		local RESOLVED_WD=$(readlink -f "$(pwd)")
		local RELATIVE_DIRECTORY=${${RESOLVED_WD#$GIT_ROOT}:1}
		[[ ${#${RELATIVE_DIRECTORY//[^\/]}} -gt 3 ]] && RELATIVE_DIRECTORY='*/%4~'

		_DIRECTORY="%B%F{green}$PROJECT_NAME%B%F{yellow}:$RELATIVE_DIRECTORY"
	}

	echo $_DIRECTORY
}

PS1__GET_GIT_BRANCH() {
	local _GIT_BRANCH=$(\
		git branch --no-color 2>/dev/null \
		| sed "/^[^*]/d; s/* \(.*\)/ %B%F{cyan}$PS1_BRANCH_SYMBOL \1/" \
	)

	echo $_GIT_BRANCH
}

PS1__GENERATE() {
	local _INDICATOR="%B%(?.%F{green}.%F{red}) $PS1_INDICATOR_SYMBOL"
	local _USER="%B%F{magenta}$PS1_USER"
	local _SEPARATOR="%b%F{red}$PS1_SEPARATOR"
	local _DIRECTORY='$(PS1__GET_DIRECTORY)'
	local _GIT_BRANCH='$(PS1__GET_GIT_BRANCH)'

	local _PROMPT=$'\n'' %B%F{blue}%# %b%f'

	echo "$_INDICATOR $_USER $_SEPARATOR $_DIRECTORY $_GIT_BRANCH $_PROMPT"
}

setopt PROMPT_SUBST
export PS1="$(PS1__GENERATE)"

#####################################################################
return 0
