source "$HOME/.config/wryn/env/env.zsh"

[ -d "$WALLPAPER_PATH" ] \
	&& feh --recursive --randomize --bg-fill "$WALLPAPER_PATH";
