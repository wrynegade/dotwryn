#####################################################################

DEPENDENCIES+=(hostnamectl)
REQUIRED_ENV+=(DOTWRYN)

#####################################################################

${SCWRYPTS_MODULE}setup() {
	STATUS "configuring system applications"
	local \
		APPLICATION \
		CONFIG \
		SOURCE_DIR SOURCE_CONFIG \
		SYSTEM_DIR SYSTEM_CONFIG \
		;

	for SOURCE_DIR in $({
			find "${DOTWRYN}/config/system/"                         -mindepth 1 -maxdepth 1 -type d
			find "${DOTWRYN}/config/system/$(hostnamectl --static)/" -mindepth 1 -maxdepth 1 -type d
		} 2>/dev/null | sort -u)
	do
		APPLICATION="$(echo "${SOURCE_DIR}" | sed 's|.*/||')"
		case ${APPLICATION} in
			( ssh | udev )
				SYSTEM_DIR=/etc/${APPLICATION}
				;;
			( xinit )
				SYSTEM_DIR=/etc/X11/xinit/xinitrc.d/
				;;
			( * )
				SYSTEM_DIR=''
				;;
		esac

		[ "${SYSTEM_DIR}" ] && sudo [ -d "${SYSTEM_DIR}" ] \
			|| continue

		for CONFIG in $(cd -- "${SOURCE_DIR}"; find . -mindepth 1 -type f | sed 's|^\./||')
		do
			SOURCE_CONFIG="${SOURCE_DIR}/${CONFIG}"
			SYSTEM_CONFIG="${SYSTEM_DIR}/${CONFIG}"

			sudo [ -f "${SYSTEM_CONFIG}" ] && {
				STATUS "already linked '${APPLICATION}/${CONFIG}'"
				continue
			}

			sudo ln -s "${SOURCE_CONFIG}" "${SYSTEM_CONFIG}" \
				&& STATUS "linked '${APPLICATION}/${CONFIG}'" \
				|| WARNING "cannot link '${APPLICATION}/${CONFIG}'" \
				;
		done
	done
}
