#####################################################################

setup.filesystem.ensure-paths() {
	local ERRORS=0
	local directories=(
		"${XDG_CONFIG_HOME:-${HOME}/.config}/wryn"
		"${HOME}/.local/bin"
		)

	local files=(
		"${HOME}/.zshrc"
		)

	echo.status 'ensuring required paths exist'
	local directory
	for directory in "${directories[@]}"
	do
		mkdir -p -- "${directory}" || echo.error "failed to create directory '${directory}'"
	done
	unset directory

	local file
	for file in "${files[@]}"
	do
		touch -- "${file}" || echo.error "failed to create file '${file}'"
	done
	unset file

	[[ "${ERRORS}" -eq 0 ]] \
		&& echo.success 'required paths ready' \
		|| echo.error 'failed to ensure required paths' \
		;

	return "${ERRORS}"
}
