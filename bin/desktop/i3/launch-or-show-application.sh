CLIENT_CLASS="$1"
APPLICATION="$2"

echo "client class:'$CLIENT_CLASS'"
echo "application :'$APPLICATION'"

xdotool search --class "$CLIENT_CLASS" >/dev/null 2>&1 || {
	i3-msg "exec --no-startup-id $APPLICATION;"
}

XFFSET=0.0
YFFSET=0.0
FACTOR=0.8
case $(basename $APPLICATION) in
	audio ) FACTOR=0.4 YFFSET=200  ;;
	email ) FACTOR=0.8 XFFSET=-200 ;;
esac

WINDOW_SIZE=$(\
	xrandr \
		| grep 'connected primary' \
		| sed 's/.*connected primary \([^x]*\)x\([^+]*\).*/\1 \2/' \
		| awk -v f=$FACTOR -v x=$XFFSET -v y=$YFFSET \
			'{print int($1*f+x)," ",int($2*f+y);}'\
)

i3-msg "[class=$CLIENT_CLASS] move scratchpad"
i3-msg "[class=$CLIENT_CLASS] resize set $WINDOW_SIZE"
i3-msg "[class=$CLIENT_CLASS] scratchpad show"
i3-msg "[class=$CLIENT_CLASS] move position center"
