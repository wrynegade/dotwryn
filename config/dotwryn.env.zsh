#####################################################################
### default .wryn configuration settings ############################
#####################################################################

# installation path for this repository
export DOTWRYN="$HOME/.wryn"

# order of editor preference
export PREFERRED_EDITORS=(vim vi nano)

# prompt generator settings
PS1_BRANCH_SYMBOL=''
PS1_INDICATOR_SYMBOL='☕'
PS1_SEPARATOR='::'
PS1_USER='%m'

# run at each zsh login
WELCOME () {
	[[ $TERM =~ tmux ]] && return 0
	{ figlet 'Welcome, beautiful'; cowsay -p 'damn u sexy'; } | lolcat
}
