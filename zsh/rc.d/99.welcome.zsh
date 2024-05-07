case $TERM in
	*kitty* | *alacritty* )
		# when using desktop terminal emulators, automatically launch tmux/omni
		# if no active omni client can be found
		: \
			&& [[ $(tmux -L omni.socket list-clients 2>/dev/null | wc -l) -eq 0 ]] \
			&& scwrypts tmux omni \
			|| WELCOME \
			;
		;;
	* ) WELCOME ;;
esac
