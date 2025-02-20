#####################################################################

DEPENDENCIES+=(ffprobe)

#####################################################################

${scwryptsmodule}() {
	local FILENAME="$1"

	[ "${FILENAME}" ] && [ -f "${FILENAME}" ] \
		|| ERROR "invalid or missing file '${FILENAME}'" \
		|| return 1

	ffprobe \
		-v quiet \
		-show_entries format=duration \
		-of default=noprint_wrappers=1:nokey=1 \
		-i "${FILENAME}" \
		;
}
