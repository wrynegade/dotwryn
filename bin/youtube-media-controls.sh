#
# Chrome / YouTube only accepts keypresses when window is active
#
# This activates the YouTube window, sends the keypress, then reactivates the original window
#

xdotool search --name 'YouTube Music' >/dev/null 2>&1 || return 1;

ACTIVE_DESKTOP="$(xdotool get_desktop)"
ACTIVE_WINDOW_ID="$(xdotool getactivewindow)"
ACTIVE_WINDOW_NAME="$(xdotool getwindowname $ACTIVE_WINDOW_ID)"

case $1 in
	next) KEY_COMMAND='j';;
	prev) KEY_COMMAND='k';;
	*) KEY_COMMAND='space';;
esac

xdotool search --name 'YouTube Music' windowactivate;
sleep 0.05;
xdotool key --clearmodifiers "$KEY_COMMAND";

xdotool set_desktop "$ACTIVE_DESKTOP";
[[ "$ACTIVE_WINDOW_NAME" != "Desktop" ]] && xdotool windowactivate "$ACTIVE_WINDOW_ID";
