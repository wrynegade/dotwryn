CLIENT_CLASS="$1"
APPLICATION="$2"

echo "client class:'$CLIENT_CLASS'"
echo "application :'$APPLICATION'"

xdotool search --class "$CLIENT_CLASS" >/dev/null 2>&1 || {
	i3-msg "exec --no-startup-id $APPLICATION;"
}

i3-msg "[class=$CLIENT_CLASS] move scratchpad";
i3-msg "[class=$CLIENT_CLASS] scratchpad show";
