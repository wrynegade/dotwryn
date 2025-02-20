#####################################################################

use scwrypts/get-realpath

use system/symlinks/get-all --group dotwryn
use system/zshparse --group dotwryn

#####################################################################

${scwryptsmodule}() {
	local PARSERS=(dotwryn.system.zshparse.dry-run)
	eval "$(utils.parse.autosetup)"
	##########################################
	local SYMLINK SOURCE_CONFIG TARGET_CONFIG SYMLINK_COUNT DRY_RUN_OUTPUT
	local SUDO_PREFIX SUDO=not-checked
	while read SYMLINK
	do
		((SYMLINK_COUNT+=1))
		SOURCE_CONFIG="$(scwrypts.get-realpath "$(echo ${SYMLINK} | awk '{print $1;}')")"
		TARGET_CONFIG="$(scwrypts.get-realpath "$(echo ${SYMLINK} | awk '{print $2;}')")"

		[ "${SOURCE_CONFIG}" ] && [ "${TARGET_CONFIG}" ] \
			|| echo.error "bad symlink entry : ${SYMLINK}" \
			|| continue

		case "${TARGET_CONFIG}" in
			( /etc/* )
				case ${SUDO} in
					( not-checked )
						echo.status "detected link(s) which require root access"
						utils.io.getsudo && {
							SUDO=checked
						} || {
							echo.status "skipping all links which require root access"
							SUDO=denied
							((SYMLINK_COUNT+=-1))
							continue
						}
						;;
					( denied )
						((SYMLINK_COUNT+=-1))
						continue
						;;
					( checked ) ;;
				esac
				SUDO_PREFIX="sudo "
				;;
			( * )
				SUDO_PREFIX=""
				;;
		esac


		[[ ${DRY_RUN} =~ true ]] \
			&& DRY_RUN_OUTPUT+="\n${SUDO_PREFIX}^ln -sf --^\"${SOURCE_CONFIG}\"^\"${TARGET_CONFIG}\"^" \
			&& continue \
			;

		: \
			&& [ ! -f "${SOURCE_CONFIG}" ] && [ ! -d "${SOURCE_CONFIG}" ] \
			&& [ ! -f "${TARGET_CONFIG}" ] && [ ! -d "${TARGET_CONFIG}" ] \
			&& echo.status "${SOURCE_CONFIG} is a new file" \
			&& mkdir -p -- "$(basename -- "${SOURCE_CONFIG}")" \
			&& touch "${SOURCE_CONFIG}" \
			;

		: \
			&& [ ! -f "${SOURCE_CONFIG}" ] && [ ! -d "${SOURCE_CONFIG}" ] \
			&& [ -f "${TARGET_CONFIG}" ] \
			&& echo.status "${SOURCE_CONFIG} is not tracked yet; copying from ${TARGET_CONFIG}" \
			&& mkdir -p -- "$(basename -- "${SOURCE_CONFIG}")" \
			&& cp -- "${TARGET_CONFIG}" "${SOURCE_CONFIG}" \
			;

		[ ! -f "${SOURCE_CONFIG}" ] && [ ! -d "${SOURCE_CONFIG}" ] && {
			echo.error "symlink entry is either misconfigured or requires manual intervention\n${SYMLINK}"
			continue
		}

		: \
			&& eval "${SUDO_PREFIX}mkdir -p -- $(dirname -- "${TARGET_CONFIG}")" \
			&& eval "${SUDO_PREFIX}ln -sf -- ${SOURCE_CONFIG} ${TARGET_CONFIG}" \
			&& echo.success "successfully linked '$(echo "${TARGET_CONFIG}" | sed "s|${HOME}/||")'" \
			|| echo.error   "error creating symlink\n${SYMLINK}" \
			;
	done < <(dotwryn.system.symlinks.get-all | grep '[^	]')

	case ${DRY_RUN} in
		( true )
			echo "${DRY_RUN_OUTPUT}" | column -ts '^'
			[[ ${ERRORS} -eq 0 ]] \
				&& echo.success "detected ${SYMLINK_COUNT} symlink(s)" \
				|| echo.error   "encountered ${ERRORS} / ${SYMLINK_COUNT} symlink processing error(s)"
			;;

		( false )
			[[ ${ERRORS} -eq 0 ]] \
				&& echo.success "successfully linked ${SYMLINK_COUNT} / ${SYMLINK_COUNT} symlink(s)" \
				|| echo.error   "failed to link ${ERRORS} / ${SYMLINK_COUNT} symlink(s)" \
				;
			;;
	esac

}

#####################################################################

${scwryptsmodule}.parse() { return 0; }
${scwryptsmodule}.parse.usage() {
	USAGE__description='
		establishes all symlinks defined in dotwryn/system/user/get-all-symlinks
	'
}
