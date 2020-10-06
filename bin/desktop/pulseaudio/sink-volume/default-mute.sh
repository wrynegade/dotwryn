pactl set-sink-mute @DEFAULT_SINK@ toggle
$HOME/.config/wryn/sfx mute &
notify-send 'Default Sink' "$(amixer sget Master | grep -q '\[on\]' && echo unmuted || echo muted)"
