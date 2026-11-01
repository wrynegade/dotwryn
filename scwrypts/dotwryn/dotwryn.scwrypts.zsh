readonly ${scwryptsgroup}__type=zsh
readonly ${scwryptsgroup}__color=$(utils.colors.red)

#####################################################################

[ "${DOTWRYN}" ] \
	|| export DOTWRYN=$(git -C "${0:a:h}" rev-parse --show-toplevel 2>/dev/null)

export DOTWRYN_HOSTNAME=$(hostnamectl --static 2>/dev/null || hostname 2>/dev/null | sed 's/\.local$//')

[ "${XDG_CONFIG_HOME}" ] \
	|| export XDG_CONFIG_HOME="${HOME}/.config"

[ "${XDG_DATA_HOME}" ] \
	|| export XDG_DATA_HOME="${HOME}/.local/share"

##########################################

for DOTWRYN_REQUIRED_VAR in \
	DOTWRYN \
	DOTWRYN_HOSTNAME \
	;
do
	[ "${(P)DOTWRYN_REQUIRED_VAR}" ] \
		|| echo.error "cannot determine ${DOTWRYN_REQUIRED_VAR}" \
		|| return 1
done

unset DOTWRYN_REQUIRED_VAR

#####################################################################

dotwryn.config() {
	local value values=()
	local set_variable="${2}"

	##########################################

	case "${1}" in
		( colorscheme.path )
			value="${DOTWRYN}/config/colorschemes"
			mkdir -p -- "${value}"
			;;

		( colorscheme.active.path )
			value="$(dotwryn.config colorscheme.path)/active"
			mkdir -p -- "${value}"
			;;

		( colorscheme.active.source )
			value="$(dotwryn.config colorscheme.active.path)/source.yaml"
			;;

		( colorscheme.active.default-material-references )
			value="$(dotwryn.config colorscheme.active.path)/default.yaml"
			;;

		( colorscheme.themes )
			local _theme
			while IFS= read -r _theme
			do
				values+=("${_theme}")
			done < <(
				cd -- "$(dotwryn.config colorscheme.path)"
				find . -mindepth 1 -maxdepth 1 -type f -name \*.yaml \
					| sed 's|^./||; s|\.yaml$||' \
			)
			unset _theme
			;;

		( colorscheme.supported-apps )
			use --group dotwryn desktop/colorscheme/apps \
				|| echo.error 'cannot determine supported apps due to module load error' \
				|| return 1

			local _app
			while IFS= read -r _app
			do
				values+=("${_app}")
			done < <(typeset -f + | sed -n 's/^_GENERATE_THEME__//p')
			unset _app
			;;
	esac

	##########################################

	local value_type=none
	[[ "${value}"            ]] && value_type=scalar
	[[ "${#values[@]}" -gt 0 ]] && value_type=array

	case "${value_type}" in
		( none ) return 1 ;;

		( scalar )
			case "${set_variable}" in
				( '' ) echo "${value}" ;;
				( *  ) ${set_variable}="${value}" ;;
			esac
			;;
		( array )
			case "${set_variable}" in
				( '' ) printf '%s\n' "${values[@]}" ;;
				( * ) eval "${set_variable}=(${(q)values[@]})" ;;
			esac
	esac
}
