_COLORSCHEME_FILE__kitty="${DOTWRYN}/config/user/kitty/theme.conf"

_GENERATE_THEME__kitty() {
	echo "# do not edit; generated by scwrypts
# theme : ${THEME_NAME}
color0 #${BLACK}
color1 #${RED}
color2 #${GREEN}
color3 #${YELLOW}
color4 #${BLUE}
color5 #${MAGENTA}
color6 #${CYAN}
color7 #${WHITE}
color8 #${BRIGHT_BLACK}
color9 #${BRIGHT_RED}
color10 #${BRIGHT_GREEN}
color11 #${BRIGHT_YELLOW}
color12 #${BRIGHT_BLUE}
color13 #${BRIGHT_MAGENTA}
color14 #${BRIGHT_CYAN}
color15 #${BRIGHT_WHITE}
cursor #${CURSOR}
background #${BACKGROUND}
foreground #${FOREGROUND}
selection_background #${SELECTION_BACKGROUND}
selection_foreground #${SELECTION_FOREGROUND}
" | sed '$d' > "${_COLORSCHEME_FILE__kitty}"
}

_SET_THEME__kitty() {
	return 0  # theme is referenced explicitly after generation
}
