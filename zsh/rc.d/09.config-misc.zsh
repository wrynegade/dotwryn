#####################################################################

# I hate the default "$HOME/go" go path; hide it away
[ $GOPATH ] \
	|| export GOPATH="$HOME/.local/go"

# not sure if this is needed anymore since I've moved to alacritty,
# but leaving this here since it was obnoxious to find
which kitty &>/dev/null \
	&& kitty + complete setup zsh | source /dev/stdin

# many tmux workflows like to interact with the X-server; however,
# the tmux sessions frequently start before the X-session
[[ $TERM =~ tmux ]] && [ ! $DISPLAY ] && export DISPLAY=:0

#RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

#####################################################################
return 0
