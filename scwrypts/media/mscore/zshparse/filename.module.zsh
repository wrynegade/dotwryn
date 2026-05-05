REQUIRED_ENV+=(MSCORE__SCORES_PATH)

${scwryptsmodule}() {
	# local MSCORE_FILENAME
	local PARSED=0

	case $1 in
		( --filename )
			PARSED=2
			MSCORE_FILENAME="$2"
			;;
	esac

	return $PARSED
}

#####################################################################

${scwryptsmodule}.usage() {
	USAGE__options+="
		--filename <string>   a valid mscore filename
	"
}

${scwryptsmodule}.validate() {
	case "${MSCORE_FILENAME}" in
		( '' )
			MSCORE__SCORES_PATH
			MSCORE_FILENAME="$(cd "${MSCORE__SCORES_PATH}"; find . -type f | grep '\.msc[zx]$' | utils.fzf 'select a score')"

			[ "${MSCORE_FILENAME}" ] && [ -f "${MSCORE__SCORES_PATH}/${MSCORE_FILENAME}" ] \
				|| ERROR "invalid score '${MSCORE_FILENAME}'"

			MSCORE_FILENAME="${MSCORE__SCORES_PATH}/${MSCORE_FILENAME}"
			;;

		( * )
			[ -f "${MSCORE_FILENAME}" ] \
				|| ERROR "no score '${MSCORE_FILENAME}' exists"
			;;
	esac

	[[ ${ERRORS} -eq 0 ]] || return

	local TEMP_PATH="${SCWRYPTS_TEMP_PATH}/mscore"
	local MSCORE_BASENAME="$(basename -- ${MSCORE_FILENAME} | sed 's/\.[^.]*$//')"
	local TEMP_FILE="${TEMP_PATH}/${MSCORE_BASENAME}.mscx"

	case "${MSCORE_FILENAME}" in
		( *.mscz )
			mkdir -p "${TEMP_PATH}/zip"
			{
				cp "${MSCORE_FILENAME}" "${TEMP_PATH}/zip/${MSCORE_BASENAME}.zip"
				cd "${TEMP_PATH}/zip"
				unzip "${MSCORE_BASENAME}.zip"
				cp "./${MSCORE_BASENAME}.mscx" "${TEMP_FILE}"
			}
			;;

		( *.mscx )
			mkdir -p "${TEMP_PATH}"
			cp "${MSCORE_FILENAME}" "${TEMP_FILE}"
			;;
	esac

	[ -f "${TEMP_FILE}" ] \
		&& MSCORE_FILENAME="${TEMP_FILE}" \
		|| ERROR "failed to extract '${TEMP_FILE}'" \
		|| MSCORE_FILENAME='' \
		;

}
