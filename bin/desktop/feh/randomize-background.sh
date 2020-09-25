WALLPAPER_DIR="$HOME/.config/wryn/wallpaper";

[ -d $WALLPAPER_DIR ] \
	&& feh --recursive --randomize --bg-fill "$WALLPAPER_DIR";
