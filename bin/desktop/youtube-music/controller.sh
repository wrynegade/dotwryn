#
# Chrome / YouTube only accepts keypresses when window is active
#
# This activates the YouTube window and sends the keypress
#

xdotool search --name 'YouTube Music' >/dev/null 2>&1 || return 1;

TIMEOUT='0.3';

case $1 in
	next) KEY_COMMAND='j';;
	prev) KEY_COMMAND='k';;
	*) KEY_COMMAND='space';;
esac

xdotool search --name 'YouTube Music' windowactivate;
sleep $TIMEOUT;
xdotool key --clearmodifiers "$KEY_COMMAND";
