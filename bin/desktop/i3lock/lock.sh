# requires i3lock-color
INSIDE_VER='001020'
RING_VER='004040'

INSIDE_WRONG='200010'
RING_WRONG='4a0020'

INSIDE='002010'
RING='103020'
LINE='8888ff'
KEYDOWN='44ff44'
KEYREMOVE='4444ff'

TIME='aaaaaa'
DATE='888888'

i3lock\
	-e\
	--pass-screen-keys --pass-media-keys --pass-volume-keys --pass-power-keys\
	-B 6\
	--force-clock\
	--insidevercolor=$INSIDE_VER --ringvercolor=$RING_VER --verifcolor=$INSIDE_VER\
	--insidewrongcolor=$INSIDE_WRONG --ringwrongcolor=$RING_WRONG --wrongcolor=$INSIDE_WRONG\
	--insidecolor=002010 --ringcolor=103020\
	--linecolor=$LINE\
	--timecolor=$TIME --datecolor=$DATE\
	--keyhlcolor=$KEYDOWN --bshlcolor=$KEYREMOVE\
	;
