#####################################################################

DEPENDENCIES+=(canberra-gtk-play)
REQUIRED_ENV+=()

use notify

#####################################################################

media.audio.play-sfx() {
	local SCWRYPTS_NOTIFICATION_ENGINES=(echo notify.desktop)
	local SFX_FILE
	case $1 in
		( volume    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-message.oga             ;;
		( mute      ) SFX_FILE=$DESKTOP__SFX_PATH/smooth-dialog-warning.oga    ;;
		( backlight ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-audio-volume-change.oga ;;
		( login     ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-desktop-login.oga       ;;
		( logout    ) SFX_FILE=$DESKTOP__SFX_PATH/smooth-desktop-login.oga     ;;
		( notify    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-complete.oga            ;;
		( undock    ) SFX_FILE=$DESKTOP__SFX_PATH/yaru-desktop-login.oga       ;;
		( homedock  ) SFX_FILE=$DESKTOP__SFX_PATH/homedock.oga                 ;;
		( gamedock  ) SFX_FILE=$DESKTOP__SFX_PATH/gamedock.oga                 ;;

		* ) SFX_FILE="$1"
		;;
	esac

	[ ! -f $SFX_FILE ] && SFX_FILE="$DESKTOP__SFX_PATH/$SFX_FILE"

	[ -f $SFX_FILE ] \
		&& echo.status "detected file '$SFX_FILE'" \
		|| notify.error "unable to locate sfx file '$1'" \
		|| return 1 \
		;

	echo.status 'starting playback'
	canberra-gtk-play -f "$SFX_FILE" \
		&& echo.success "finished output of '$SFX_FILE'" \
		|| notify.error "something went wrong playing file '$SFX_FILE'" \
		|| return 1 \
		;
}
