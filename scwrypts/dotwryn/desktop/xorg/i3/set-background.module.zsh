#####################################################################

use scwrypts/get-realpath

#####################################################################

${scwryptsmodule}() {
	local ERRORS=0
	local feh_args=(--no-fehbg --bg-fill)

	local selection="${1}"

	local configured_wallpaper_path_required mode
	case "${selection}" in
		( random | --random )
			[[ "${selection}" == random ]] && echo.warning.deprecation 'desktop' 'flag "random" has been replaced with "--random"'
			mode=random
			configured_wallpaper_path_required=true
			;;

		( /* | ~/* | .* )
			mode=explicit-filepath
			configured_wallpaper_path_required=false
			;;

		( '' )
			mode=interactive
			configured_wallpaper_path_required=true
			;;

		( * )
			mode=basename
			configured_wallpaper_path_required=true
			;;
	esac

	local desktop_wallpaper_realpath
	case "${configured_wallpaper_path_required}" in
		( false ) ;;
		( true )
			utils.environment.check DESKTOP__WALLPAPER_PATH \
				|| return 1

			desktop_wallpaper_realpath="$(scwrypts.get-realpath "${DESKTOP__WALLPAPER_PATH}")"

			[[ "${desktop_wallpaper_realpath}" ]] && [[ -d "${desktop_wallpaper_realpath}" ]] \
				|| echo.error "wallpaper path missing or invalid" -v DESKTOP__WALLPAPER_PATH -v desktop_wallpaper_realpath \
				|| return 1
			;;
	esac

	local background background_type=file
	case "${mode}" in
		( random )
			background="${desktop_wallpaper_realpath}"
			background_type=directory
			feh_args+=(--recursive --randomize)
			;;

		( interactive )
			background="$(utils.fzf.file-select --prompt 'select a background' "${desktop_wallpaper_realpath}")"
			;;

		( explicit-filepath )
			background="$(scwrypts.get-realpath "${selection}")"
			;;

		( basename )
			local selection_has_filetype \
				&& [[ "${selection:e}" ]] \
				&& selection_has_filetype=true \
				|| selection_has_filetype=false \
				;

			case "${selection_has_filetype}" in
				( true )
					background="${desktop_wallpaper_realpath}/${selection}"
					[[ -f "${background}" ]] \
						|| echo.error "missing or invalid file '${selection}'" -v desktop_wallpaper_realpath
					;;

				( false )
					local file_type file_types=(png jpg jpeg)
					for file_type in "${file_types[@]}" "${file_types[@]:u}"
					do
						background="${desktop_wallpaper_realpath}/${selection}.${file_type}"
						[[ -f "${background}" ]] && break
						file_type=''
					done

					[[ "${file_type}" ]] \
						|| echo.error "no image files matched '${selection}'" -v desktop_wallpaper_realpath \
						|| return 1
				;;
			esac
			;;
	esac

	case "${background_type}" in
		( file )
			[[ "${background}" ]] && [[ -f "${background}" ]] \
				|| echo.error "missing or invalid wallpaper file '${selection}'" -v background \
				|| return 1
			;;

		( directory )
			[[ "${background}" ]] && [[ -d "${background}" ]] \
				|| echo.error "missing or invalid wallpaper directory '${selection}'" -v background \
				|| return 1
			;;
	esac

	feh "${feh_args[@]}" "${background}"
}
