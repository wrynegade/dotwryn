APPLICATION_BIN="$HOME/.config/wryn/default-applications"
APPLICATIONS=(
	'audio'
	'discord'
	'email'
	'media'
	'message'
	'phone'
	'slack'
	)

CLIENT_CLASSES=(
	'^Pavucontrol$'
	'^discord$'
	'^Thunderbird$'
	'^youtubemusic-nativefier'
	'^android-messages-desktop$'
	'^google-voice-desktop'
	'^Slack$'
	)

for APPLICATION in $(echo $APPLICATIONS); do
	xdotool search --class "$CLIENT_CLASS" >/dev/null 2>&1 || {
		i3-msg "exec --no-startup-id $APPLICATION_BIN/$APPLICATION;"
	}
done

sleep 10;

for CLIENT_CLASS in $CLIENT_CLASSES; do
	i3-msg "[class=$CLIENT_CLASS] move scratchpad";
done
