#####################################################################

setup.git() {
	local sources_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/project-source-code"

	SOURCE_DIR="${DOTWRYN_PATH}" \
	TARGET_DIR="${sources_dir}/yage/dotwryn" \
	REMOTE_UPSTREAMS=(
		'git@github.com:wrynegade/dotwryn.git'
		'git@yage.io:wrynegade/dotwryn.git'
		'git@bitbucket.org:wrynegade/dotwryn.git'
		) setup.git._.remotes '.wryn'

	SOURCE_DIR="${DOTWRYN_PATH}/zsh/plugins/code-activator" \
	TARGET_DIR="${sources_dir}/zsh/code-activator" \
	REMOTE_UPSTREAMS=(
		'git@yage.io:zsh/code-activator.git'
		'git@github.com:wrynegade/code-activator.git'
		) setup.git._.remotes 'zsh-plugins/code-activator'

	SOURCE_DIR="${DOTWRYN_PATH}/zsh/plugins/scwrypts" \
	TARGET_DIR="${sources_dir}/zsh/scwrypts" \
	REMOTE_UPSTREAMS=(
		'git@yage.io:zsh/scwrypts'
		'git@github.com:wrynegade/scwrypts'
		) setup.git._.remotes 'zsh-plugins/scwrypts'

	return 0
}

setup.git._.remotes() {
	: \
		&& [ "${SOURCE_DIR}" ] \
		&& [ "${TARGET_DIR}" ] \
		&& [[ ${#REMOTE_UPSTREAMS[@]} -gt 0 ]] \
		|| return 1

	[ "$1" ] && echo.status "updating remotes for '$1'"

	git -C "${SOURCE_DIR}" remote rm upstream 2>/dev/null
	git -C "${SOURCE_DIR}" remote add upstream "${REMOTE_UPSTREAMS[1]}"

	local remote_upstream
	for remote_upstream in "${REMOTE_UPSTREAMS[@]}"
	do
		git -C "${SOURCE_DIR}" remote set-url --add --push upstream "${remote_upstream}"

		case "${remote_upstream}" in
			( git@github.com:* )
				git -C "${SOURCE_DIR}" remote rm  github 2>/dev/null
				git -C "${SOURCE_DIR}" remote add github "${remote_upstream}"
				;;
			( git@yage.io:* )
				git -C "${SOURCE_DIR}" remote rm  yage 2>/dev/null
				git -C "${SOURCE_DIR}" remote add yage "${remote_upstream}"
				;;
			( git@bitbucket.org:* )
				git -C "${SOURCE_DIR}" remote rm  bitbucket 2>/dev/null
				git -C "${SOURCE_DIR}" remote add bitbucket "${remote_upstream}"
				;;
		esac
	done
	unset remote_upstream

	SOURCE_DIR="${SOURCE_DIR}" TARGET_DIR="${TARGET_DIR}" setup.git._.link-to-projects \
		|| echo.warning "failed to link '${TARGET_DIR}'"

	return 0
}

setup.git._.link-to-projects() {
	[ "${TARGET_DIR}" ] && [ "${SOURCE_DIR}" ] \
		|| return 1

	{
		mkdir -p "${TARGET_DIR}"
		rm "${TARGET_DIR}/code"
		ln -s "${SOURCE_DIR}" "${TARGET_DIR}/code"
	} &>/dev/null
}
