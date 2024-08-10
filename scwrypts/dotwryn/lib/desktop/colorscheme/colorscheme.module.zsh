#####################################################################

_COLORSCHEME_DIR="$DOTWRYN/colorschemes"

ACTIVE_THEME_PATH="$_COLORSCHEME_DIR/active"
ACTIVE_THEME_SOURCE="$ACTIVE_THEME_PATH/source.yaml"

use desktop/colorscheme/alacritty --group dotwryn
use desktop/colorscheme/flameshot --group dotwryn
use desktop/colorscheme/getty --group dotwryn
use desktop/colorscheme/kitty --group dotwryn
use desktop/colorscheme/polybar --group dotwryn
use desktop/colorscheme/rofi --group dotwryn

COLORSCHEME__SUPPORTED_CONFIG_TYPES=($(typeset -f + | sed -n 's/^_GENERATE_THEME__//p'))

DEFAULT_MATERIAL_REFERENCES="$ACTIVE_THEME_PATH/default.yaml"

DEPENDENCIES+=(sed yq)

__CHECK_ENV_VAR DESKTOP__WALLPAPER_PATH --optional

#####################################################################

MAX_LOOKUP_RECURSION=10
GET_COLORSCHEME_HEX() {
	[ ! $USAGE ] && USAGE="
		usage: ...args... [...options...]

		options:
		  -t, --theme          get the colorscheme value for the indicated theme source
		  -l, --list-themes    show available color themes and exit

		args:
		  An ordered list of colorscheme lookup terms. The first term is preferred, and
		  subsequent lookup terms are used as fallback.

		  Some special terms are allowed (typically for compatibility); however,
		  these should be simple yq queries from the 'colorscheme/\$THEME_NAME.yaml'
		     (e.g. '.ansi.red.bright')

		  Special terms:
		    [0-15]        : lookup by ANSI color number
			compatibility : foreground | background | cursor | selection_foreground | selection_background
	"

	local THEME_NAME='current active theme'
	local THEME_SOURCE="$ACTIVE_THEME_SOURCE"
	local ARGS=()
	local LOOKUPS=()
	while [[ $# -gt 0 ]]
	do
		case $1 in
			-t | --theme )
				THEME_NAME=$2; shift 1
				THEME_SOURCE="$_COLORSCHEME_DIR/$THEME_NAME.yaml"
				[ -f "$THEME_SOURCE" ] \
					|| ERROR "no such theme '$THEME_NAME' exists"
				;;

			-l | --list-themes ) _LIST_THEMES; return 0 ;;

			[0-9] | 1[0-5] ) LOOKUPS+=($(_GET_YAML_LOOKUP_FOR_ANSI_COLOR $1)) ;;

			foreground           ) LOOKUPS+=(.foreground           .ansi.gray.black) ;;
			background           ) LOOKUPS+=(.background           .ansi.gray.white) ;;
			cursor               ) LOOKUPS+=(.cursor               .ansi.gray.white) ;;
			selection_foreground ) LOOKUPS+=(.selection.foreground .background     ) ;;
			selection_background ) LOOKUPS+=(.selection.background .foreground     ) ;;

			* ) LOOKUPS+=("$1") ;;
		esac
		shift 1
	done

	[[ ${#LOOKUPS[@]} -gt 0 ]] \
		|| ERROR 'must provide at least one color lookup'

	CHECK_ERRORS --no-fail || return 1

	##########################################

	local LOOKUP VALUE
	local I INIT
	for LOOKUP in ${LOOKUPS[@]}
	do
		I=0 INIT=$LOOKUP
		while true
		do
			((I+=1))
			VALUE=$(YQ eval-all '. as $item ireduce ({}; . * $item)' "$DEFAULT_MATERIAL_REFERENCES" "$THEME_SOURCE" | YQ -r $LOOKUP)
			DEBUG "looking up $LOOKUP : $VALUE"
			case $VALUE in
				.* ) LOOKUP=$VALUE ;;
				* ) break ;;
			esac
			[[ $I -ge $MAX_LOOKUP_RECURSION ]] && {
				VALUE=null
				WARNING "max recursive depth reached for '$INIT'"
				break
			}
		done

		[[ $VALUE =~ null ]] && continue
		[[ $VALUE =~ ^$   ]] && continue
		break
	done

	[[ $VALUE =~ null ]] && {
		ERROR "color lookup error for '$LOOKUPS'"
		return 1
	}

	echo $VALUE | sed 's/^#//'
}

SET_THEME() {
	[ ! $USAGE ] && USAGE="
		usage: [...options...]

		options:
		  -t, --theme          one of the available color themes
		  -l, --list-themes    show available color themes and exit

		  --only   only set the theme for a specific terminal/application
                   ($COLORSCHEME__SUPPORTED_CONFIG_TYPES)

		  -h, --help   show this dialogue and exit

		args:
		  \$1   shorthand for '--theme \$1'

		generate all source-controlled theme files then link them to the
		appropriate local theme file to immediately update terminal themes

		Note : 'i3wm colorscheme' configuration is supported but must be performed
		       through the 'desktop/xorg/i3 --group dotwryn' module due to
			   some odd complexity
	"
	local THEME_NAME CONFIG_TYPE
	local UPDATE_ACTIVE_THEME=true
	while [[ $# -gt 0 ]]
	do
		case $1 in
			-t | --theme       ) THEME_NAME=$2; shift 1 ;;
			-l | --list-themes ) _LIST_THEMES; return 0 ;;

			--only )
				UPDATE_ACTIVE_THEME=false
				CONFIG_TYPE=$2; shift 1
				command -v _SET_THEME__$CONFIG_TYPE >/dev/null 2>&1 \
					|| ERROR "configuration for '$CONFIG_TYPE' not supported"
				;;

			-h | --help ) USAGE; return 0 ;;

			* ) [ ! $THEME_NAME ] \
					&& THEME_NAME=$1 \
					|| ERROR "unknown argument '$1'" \
					;
		esac
		shift 1
	done

	CHECK_ERRORS --no-fail || return 1

	##########################################

	[ $THEME_NAME ] || THEME_NAME=$(_LIST_THEMES | FZF 'select a theme')
	[ $THEME_NAME ] || ABORT

	local SOURCE_THEME="$_COLORSCHEME_DIR/$THEME_NAME.yaml"
	[ -f "$SOURCE_THEME" ] \
		|| ERROR "no such theme '$THEME_NAME'" \
		|| return 1

	##########################################

	[[ $UPDATE_ACTIVE_THEME =~ true ]] && {
		mkdir -p "$ACTIVE_THEME_PATH" &>/dev/null
		STATUS "updating active theme" \
			&& ln -sf "$SOURCE_THEME" "$ACTIVE_THEME_SOURCE" \
			&& SUCCESS "active theme set to '$THEME_NAME'" \
			|| ERROR "unable to set active theme to '$THEME_NAME'" \
			|| return 2
	}

	local CONFIG_TYPES=()
	[ $CONFIG_TYPE ] \
		&& CONFIG_TYPES=($CONFIG_TYPE) \
		|| CONFIG_TYPES=($COLORSCHEME__SUPPORTED_CONFIG_TYPES) \
		;

	_GET_HEX() { GET_COLORSCHEME_HEX --theme $THEME_NAME $@; }
	# allow simple ANSI-color reference
	local          BLACK=$(_GET_HEX .ansi.gray.black     )
	local   BRIGHT_BLACK=$(_GET_HEX .ansi.gray.regular   )
	local            RED=$(_GET_HEX .ansi.red.regular    )
	local     BRIGHT_RED=$(_GET_HEX .ansi.red.bright     )
	local          GREEN=$(_GET_HEX .ansi.green.regular  )
	local   BRIGHT_GREEN=$(_GET_HEX .ansi.green.bright   )
	local         YELLOW=$(_GET_HEX .ansi.yellow.regular )
	local  BRIGHT_YELLOW=$(_GET_HEX .ansi.yellow.bright  )
	local           BLUE=$(_GET_HEX .ansi.blue.regular   )
	local    BRIGHT_BLUE=$(_GET_HEX .ansi.blue.bright    )
	local        MAGENTA=$(_GET_HEX .ansi.magenta.regular)
	local BRIGHT_MAGENTA=$(_GET_HEX .ansi.magenta.bright )
	local           CYAN=$(_GET_HEX .ansi.cyan.regular   )
	local    BRIGHT_CYAN=$(_GET_HEX .ansi.cyan.bright    )
	local          WHITE=$(_GET_HEX .ansi.gray.white     )
	local   BRIGHT_WHITE=$(_GET_HEX .ansi.gray.bright    )
	local     FOREGROUND=$(_GET_HEX .foreground          )
	local     BACKGROUND=$(_GET_HEX .background          )
	local         CURSOR=$(_GET_HEX .cursor              )

	for CONFIG_TYPE in ${CONFIG_TYPES[@]}
	do
		STATUS "updating $CONFIG_TYPE theme" \
			&& _GENERATE_THEME__$CONFIG_TYPE \
			&& _SET_THEME__$CONFIG_TYPE \
			&& SUCCESS "emulator $CONFIG_TYPE successfully updated to $THEME_NAME" \
			|| ERROR "error setting theme $THEME_NAME for $CONFIG_TYPE"

		[[ $CONFIG_TYPE =~ ^getty$ ]] && [[ $TERM =~ ^linux$ ]] && {
			STATUS 'loading getty theme now' \
				&& NO_CLEAR=1 source "$ACTIVE_THEME_PATH/getty.sh" \
				&& SUCCESS 'getty theme loaded' \
				|| ERROR 'getty theme loading error (see above)'
			}
	done

	local WALLPAPER="$(find "$DESKTOP__WALLPAPER_PATH" -type f -name $THEME_NAME.\* 2>/dev/null | head -n1)"
	[ "$WALLPAPER" ] && command -v feh &>/dev/null \
		&& feh --bg-fill "$WALLPAPER"

	CHECK_ERRORS --no-usage \
		&& echo "$THEME_NAME" > "$ACTIVE_THEME_PATH/name.txt"
}

#####################################################################

_LIST_THEMES() {
	ls "$_COLORSCHEME_DIR" | sed -n 's/.yaml$//p'
}

_GET_YAML_LOOKUP_FOR_ANSI_COLOR() {
	echo "
0: .ansi.gray.black
1: .ansi.red.regular
2: .ansi.green.regular
3: .ansi.yellow.regular
4: .ansi.blue.regular
5: .ansi.magenta.regular
6: .ansi.cyan.regular
7: .ansi.gray.white
8: .ansi.gray.regular
9: .ansi.red.bright
10: .ansi.green.bright
11: .ansi.yellow.bright
12: .ansi.blue.bright
13: .ansi.magenta.bright
14: .ansi.cyan.bright
15: .ansi.gray.bright
" | YQ -r ".$1"
}
