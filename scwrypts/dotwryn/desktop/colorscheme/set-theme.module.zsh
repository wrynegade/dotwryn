#####################################################################

use --group dotwryn desktop/colorscheme/get-hex
use --group dotwryn desktop/xorg/i3/set-background

use --group dotwryn desktop/colorscheme/apps

#####################################################################

DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES=()
dotwryn.config colorscheme.supported-apps DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES


${scwryptsmodule}() {
	local PARSERS=() DESCRIPTION='
		generate source-controlled theme files and link them to the
		appropriate applications
	'

	eval "$(utils.parse.autosetup)"

	local DEBUG_ARGS=(-v theme_name -v theme_source -v config_types)
	local TRACE_ARGS=("${DEBUG_ARGS[@]}" -v update_active_theme)

	##########################################

	local colorscheme_active_path="$(dotwryn.config colorscheme.active.path)"
	local colorscheme_active_source="$(dotwryn.config colorscheme.active.source)"

	echo.trace 'starting colorscheme update'

	case "${update_active_theme}" in
		( false ) ;;
		( true )
			echo.status "updating active theme" \
				&& (
					cd -- "${colorscheme_active_path}"
					ln -sf -- "../$(basename -- "${theme_source}")" "./$(basename -- "$(dotwryn.config colorscheme.active.source)")"
				) \
				&& echo.success "active theme set to '${theme_name}'" \
				|| echo.error "unable to set active theme to '${theme_name}'" \
				;
			;;
	esac

	_GET_HEX() { dotwryn.desktop.colorscheme.get-hex --theme "${theme_name}" "${@}"; }

	_GET_HEX . | utils.yq >/dev/null \
		|| echo.error "error loading colorscheme file; aborting" \
		|| return 1

	# allow simple ANSI-color reference
	local \
		         BLACK="$( _GET_HEX .ansi.gray.black      )" \
		  BRIGHT_BLACK="$( _GET_HEX .ansi.gray.regular    )" \
		           RED="$( _GET_HEX .ansi.red.regular     )" \
		    BRIGHT_RED="$( _GET_HEX .ansi.red.bright      )" \
		         GREEN="$( _GET_HEX .ansi.green.regular   )" \
		  BRIGHT_GREEN="$( _GET_HEX .ansi.green.bright    )" \
		        YELLOW="$( _GET_HEX .ansi.yellow.regular  )" \
		 BRIGHT_YELLOW="$( _GET_HEX .ansi.yellow.bright   )" \
		          BLUE="$( _GET_HEX .ansi.blue.regular    )" \
		   BRIGHT_BLUE="$( _GET_HEX .ansi.blue.bright     )" \
		       MAGENTA="$( _GET_HEX .ansi.magenta.regular )" \
		BRIGHT_MAGENTA="$( _GET_HEX .ansi.magenta.bright  )" \
		          CYAN="$( _GET_HEX .ansi.cyan.regular    )" \
		   BRIGHT_CYAN="$( _GET_HEX .ansi.cyan.bright     )" \
		         WHITE="$( _GET_HEX .ansi.gray.white      )" \
		  BRIGHT_WHITE="$( _GET_HEX .ansi.gray.bright     )" \
		    FOREGROUND="$( _GET_HEX .foreground           )" \
		    BACKGROUND="$( _GET_HEX .background           )" \
		        CURSOR="$( _GET_HEX .cursor               )" \
		;


	for config_type in "${config_types[@]}"
	do
		case "${config_type}" in
			( i3-background )
				dotwryn.desktop.xorg.i3.set-background "${theme_name}"
				;;

			( i3 )
				dotwryn.desktop.xorg.i3.generate-config \
				;;

			( * )
				echo.status "updating ${config_type} theme" \
					&& "_GENERATE_THEME__${config_type}" \
					&& "_SET_THEME__${config_type}" \
					&& echo.success "emulator ${config_type} successfully updated to ${theme_name}" \
					|| echo.error "error setting theme ${theme_name} for ${config_type}" \
				;;
		esac || continue

		# handle special 
		case "${config_type}" in
			( getty )
				[[ "${TERM}" == linux ]] || continue
				echo.status 'loading getty theme now' \
					&& NO_CLEAR=1 source "${colorscheme_active_path}/getty.sh" \
					&& echo.success 'getty theme loaded' \
					|| echo.error 'getty theme loading error (see above)' \
				;;
		esac
	done

	# --only regenerates one config type; the active theme (and its name) is unchanged
	[[ "${ERRORS}" -eq 0 ]] && [[ "${update_active_theme}" =~ true ]] \
		&& echo "${theme_name}" > "${colorscheme_active_path}/name.txt"

	return "${ERRORS}"
}

${scwryptsmodule}.parse.locals() {
	local ARGS=()
	local theme_name theme_source
	local update_active_theme=true
	local config_type config_types=()
}

${scwryptsmodule}.parse() {
	local parsed=0

	case "${1}" in
		( -t | --theme ) parsed=2
			theme_name="${2}"
			;;

		( -l | --list-themes ) parsed=1
			dotwryn.config colorscheme.themes
			EARLY_ESCAPE_CODE=0
			;;

		( --only ) parsed=2
			update_active_theme=false
			config_type="${2}"
			;;
	esac

	return "${parsed}"
}

${scwryptsmodule}.parse.usage() {
	[[ "${#DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES[@]}" -eq 0 ]] \

	USAGE__options+="
		-t, --theme          one of the available color themes
		-l, --list-themes    show available color themes and exit

		--only   only set the theme for a specific terminal/application
		         (${DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES[@]})
	"

	USAGE__args+='
		$1   theme name (can be used instead of -t / --theme)
	'
}

${scwryptsmodule}.parse.validate() {
	[[ "${theme_name}" ]] && [[ "${ARGS[1]}" ]] \
		&& echo.error "unknown argument '${ARGS[1]}'"

	[[ "${theme_name}" ]] || theme_name="${ARGS[1]}"
	[[ "${theme_name}" ]] || theme_name="$(dotwryn.config colorscheme.themes | utils.fzf 'select a theme')"
	[[ "${theme_name}" ]] \
		|| echo.error 'must provide theme name'

	theme_source="$(dotwryn.config colorscheme.path)/${theme_name}.yaml"
	[[ -f "${theme_source}" ]] \
		|| echo.error "no such theme '${theme_name}'"

	[[ "${#ARGS[@]}" -le 1 ]] \
		|| echo.error "unknown argument(s) ${(q)ARGS[@]:1}"

	case "${config_type}" in
		( '' ) config_types=("${DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES[@]}") ;;
		( * )
			[[ "$(zsh.is-in-array DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES "${config_type}")" ]] \
				|| echo.error "invalid config type '${config_type}' (supported: ${(q)DOTWRYN_COLORSCHEME__SUPPORTED_CONFIG_TYPES[@]})"

			config_types=("${config_type}")
			;;
	esac
}
