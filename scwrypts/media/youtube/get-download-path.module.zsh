${scwryptsmodule}() {
	local DOWNLOAD_PATH="${SCWRYPTS_DATA_PATH}/youtube"

	mkdir -p -- "${DOWNLOAD_PATH}" &>/dev/null

	echo "${DOWNLOAD_PATH}"
}
