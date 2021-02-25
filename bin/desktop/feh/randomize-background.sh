source "$HOME/.config/wryn/env/env"

[ -d "$WALLPAPER_PATH" ] \
	&& feh --recursive --randomize --bg-fill "$WALLPAPER_PATH";
