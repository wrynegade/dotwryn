#####################################################################

use desktop/notify --group dotwryn

DEPENDENCIES+=(canberra-gtk-play)
REQUIRED_ENV+=()

#####################################################################

MEDIA__PLAY_SFX() {
	local SFX_FILE
	case $1 in
		volume    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-message.oga             ;;
		mute      ) SFX_FILE=$DESKTOP__SFX_PATH/smooth-dialog-warning.oga    ;;
		backlight ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-audio-volume-change.oga ;;
		login     ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-desktop-login.oga       ;;
		logout    ) SFX_FILE=$DESKTOP__SFX_PATH/smooth-desktop-login.oga     ;;
		notify    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-complete.oga            ;;
		undock    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-desktop-login.oga       ;;
		homedock  ) SFX_FILE=$DESKTOP__SFX_PATH/homedock.oga                 ;;
		gamedock  ) SFX_FILE=$DESKTOP__SFX_PATH/gamedock.oga                 ;;

		* ) SFX_FILE="$1"
		;;
	esac

	[ ! -f $SFX_FILE ] && SFX_FILE="$DESKTOP__SFX_PATH/$SFX_FILE"

	[ -f $SFX_FILE ] \
		&& STATUS "detected file '$SFX_FILE'" \
		|| NOTIFY_FAIL 1 "unable to locate sfx file '$1'" \
		;

	STATUS 'starting playback'
	canberra-gtk-play -f "$SFX_FILE" \
		&& SUCCESS "finished output of '$SFX_FILE'" \
		|| NOTIFY_FAIL 1 "something went wrong playing file '$SFX_FILE'"
}
