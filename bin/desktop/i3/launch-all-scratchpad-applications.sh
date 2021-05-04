#!/usr/bin/zsh

APPLICATION_BIN="$HOME/.config/wryn/default-applications"
APPLICATION_CLASSES=(
	'audio ^Pavucontrol$'
	'discord ^discord$'
	'email ^Thunderbird$'
	'media ^youtubemusic-nativefier'
	'message ^android-messages-desktop$'
	'phone ^google-voice-desktop'
	'slack ^Slack$'
	)

for APP_CLS_STR in $APPLICATION_CLASSES; do
	APPLICATION_CLASS=($(echo $APP_CLS_STR))
	APPLICATION=${APPLICATION_CLASS[1]}
	CLIENT_CLASS=${APPLICATION_CLASS[2]}

	echo "launching $APPLICATION_BIN/$APPLICATION"
	xdotool search --class "$CLIENT_CLASS" >/dev/null 2>&1 && echo "found existing" || {
		i3-msg "exec --no-startup-id $APPLICATION_BIN/$APPLICATION;"
	}
done

sleep 10;

for APP_CLS_STR in $APPLICATION_CLASSES; do
	APPLICATION_CLASS=($(echo $APP_CLS_STR))
	CLIENT_CLASS=${APPLICATION_CLASS[2]}
	echo "hiding application $CLIENT_CLASS"
	i3-msg "[class=$CLIENT_CLASS] move scratchpad";
done
