#####################################################################

${scwryptsmodule}() {
	local PARSERS=() DESCRIPTION='
		provides a literal hex code for the target theme based on
		the provided lookup key(s)
	'
	eval "$(utils.parse.autosetup)"
	##########################################

	theme.yq() { echo "${theme_yaml}" | utils.yq -r "${@}" | grep -v ^null$; }

	local previously_searched_keys=()

	local lookup_key value
	for lookup_key in "${yaml_lookup_array[@]}"
	do
		while [[ "${previously_searched_keys[(Ie)${lookup_key}]}" -le 1 ]]
		do
			value="$(theme.yq "${lookup_key}")"
			case "${value}" in
				( .* )  # value resembles another key
					previously_searched_keys+=("${lookup_key}")
					lookup_key="${value}"
					;;

				( * ) break ;;
			esac
			value=null
		done

		[[ "${value}" =~ '^#' ]] && break
	done

	case "${value}" in
		( #* ) echo "${value/\#/}" ;;
		( null | '' ) echo.error "color lookup error for ${(q)yaml_lookup_array[@]}" ;;

	esac
}

${scwryptsmodule}.parse.locals() {
	local ARGS=()
	local theme_name='current active theme'
	local theme_source
	local theme_yaml
	local yaml_lookup_array=()
}

${scwryptsmodule}.parse() {
	local parsed=0

	case "${1}" in
		( -t | --theme ) parsed=2; theme_name="${2}" ;;
	esac

	return "${parsed}"
}

${scwryptsmodule}.parse.usage() {
	USAGE__options+='
		-t, --theme          get the colorscheme value for the indicated theme source
		-l, --list-themes    show available color themes and exit
	'

	USAGE__args+='
		$1..$N   lookup keys for hex color codes
		An ordered list of colorscheme lookup terms. The first term is preferred, and
		subsequent lookup terms are used as fallback.

		Some special terms are allowed (typically for compatibility); however, in
		general, these should be simple jq-style queries to pull values from the
		associated colorscheme.yaml file
		  (e.g. .ansi.red.bright)

		Special terms:
		  [0-15]        : lookup by ANSI color number
		  compatibility : foreground | background | cursor | selection_foreground | selection_background
	'
}

${scwryptsmodule}.parse.validate() {
	local _a
	for _a in "${ARGS[@]}"
	do
		case "${_a}" in
			# --- ANSI color numbers -------------------
			(  0 ) yaml_lookup_array+=(.ansi.gray.black)      ;;
			(  1 ) yaml_lookup_array+=(.ansi.red.regular)     ;;
			(  2 ) yaml_lookup_array+=(.ansi.green.regular)   ;;
			(  3 ) yaml_lookup_array+=(.ansi.yellow.regular)  ;;
			(  4 ) yaml_lookup_array+=(.ansi.blue.regular)    ;;
			(  5 ) yaml_lookup_array+=(.ansi.magenta.regular) ;;
			(  6 ) yaml_lookup_array+=(.ansi.cyan.regular)    ;;
			(  7 ) yaml_lookup_array+=(.ansi.gray.white)      ;;
			(  8 ) yaml_lookup_array+=(.ansi.gray.regular)    ;;
			(  9 ) yaml_lookup_array+=(.ansi.red.bright)      ;;
			( 10 ) yaml_lookup_array+=(.ansi.green.bright)    ;;
			( 11 ) yaml_lookup_array+=(.ansi.yellow.bright)   ;;
			( 12 ) yaml_lookup_array+=(.ansi.blue.bright)     ;;
			( 13 ) yaml_lookup_array+=(.ansi.magenta.bright)  ;;
			( 14 ) yaml_lookup_array+=(.ansi.cyan.bright)     ;;
			( 15 ) yaml_lookup_array+=(.ansi.gray.bright)     ;;

			# --- special keys -------------------------
			( foreground           ) yaml_lookup_array+=(.foreground           .ansi.gray.black) ;;
			( selection_foreground ) yaml_lookup_array+=(.selection.foreground .background     ) ;;

			( background           ) yaml_lookup_array+=(.background           .ansi.gray.white) ;;
			( selection_background ) yaml_lookup_array+=(.selection.background .foreground     ) ;;

			( cursor               ) yaml_lookup_array+=(.cursor .ansi.gray.white) ;;

			( '' ) ;;

			# --- literal lookup keys ------------------
			( * ) yaml_lookup_array+=("${_a}") ;;
		esac
	done
	unset _a

	[[ "${#yaml_lookup_array[@]}" -gt 0 ]] \
		|| echo.error "must provide at least one yaml lookup key"

	case "${theme_name}" in
		( 'current active theme' )
			theme_source="$(dotwryn.config colorscheme.active.source)"
			;;

		( * )
			theme_source="$(dotwryn.config colorscheme.path)/${theme_name}.yaml"
			;;
	esac

	[[ -f "${theme_source}" ]] \
		|| echo.error "invalid or missing theme '${theme_name}'" -v theme_source

	theme_yaml="$(
		for yamlfile in \
			"$(dotwryn.config colorscheme.active.default-material-references)" \
			"${theme_source}" \
			;
		do
			[[ "$(head -n1 "${yamlfile}")" =~ ^--- ]] || echo '---'
			sed 's/---\s*#.*$/---/' "${yamlfile}"
		done | utils.yq.combine-files
	)"

	[[ "${theme_yaml}" ]] && [[ "$(echo "${theme_yaml}" | utils.yq -r . 2>/dev/null)" ]] \
		|| echo.error "yaml theme '${theme_name}' produced invalid yaml"
}
