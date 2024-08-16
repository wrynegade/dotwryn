#####################################################################

SETUP__GIT() {
	local SOURCES_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/project-source-code"

	SOURCE_DIR="${DOTWRYN_PATH}" \
	TARGET_DIR="${SOURCES_DIR}/yage/dotwryn" \
	REMOTE_UPSTREAMS=(
		'git@github.com:wrynegade/dotwryn.git'
		'git@yage.io:wrynegade/dotwryn.git'
		'git@bitbucket.org:wrynegade/dotwryn.git'
		) SETUP__GIT__REMOTES '.wryn'

	SOURCE_DIR="${DOTWRYN_PATH}/zsh/plugins/code-activator" \
	TARGET_DIR="${SOURCES_DIR}/zsh/code-activator" \
	REMOTE_UPSTREAMS=(
		'git@yage.io:zsh/code-activator.git'
		'git@github.com:wrynegade/code-activator.git'
		) SETUP__GIT__REMOTES 'zsh-plugins/code-activator'

	SOURCE_DIR="${DOTWRYN_PATH}/zsh/plugins/scwrypts" \
	TARGET_DIR="${SOURCES_DIR}/zsh/scwrypts" \
	REMOTE_UPSTREAMS=(
		'git@yage.io:zsh/scwrypts'
		'git@github.com:wrynegade/scwrypts'
		) SETUP__GIT__REMOTES 'zsh-plugins/scwrypts'

	return 0
}

SETUP__GIT__REMOTES() {
	: \
		&& [ "${SOURCE_DIR}" ] \
		&& [ "${TARGET_DIR}" ] \
		&& [[ ${#REMOTE_UPSTREAMS[@]} -gt 0 ]] \
		|| return 1

	[ "$1" ] && STATUS "updating remotes for '$1'"

	git -C "${SOURCE_DIR}" remote rm upstream 2>/dev/null
	git -C "${SOURCE_DIR}" remote add upstream ${REMOTE_UPSTREAMS[1]}

	local REMOTE_UPSTREAM
	for REMOTE_UPSTREAM in ${REMOTE_UPSTREAMS[@]}
	do
		git -C "${SOURCE_DIR}" remote set-url --add --push upstream "${REMOTE_UPSTREAM}"

		case ${REMOTE_UPSTREAM} in
			git@github.com:* )
				git -C "${SOURCE_DIR}" remote rm  github 2>/dev/null
				git -C "${SOURCE_DIR}" remote add github "${REMOTE_UPSTREAM}"
				;;
			git@yage.io:* )
				git -C "${SOURCE_DIR}" remote rm  yage 2>/dev/null
				git -C "${SOURCE_DIR}" remote add yage "${REMOTE_UPSTREAM}"
				;;
			git@bitbucket.org:* )
				git -C "${SOURCE_DIR}" remote rm  bitbucket 2>/dev/null
				git -C "${SOURCE_DIR}" remote add bitbucket "${REMOTE_UPSTREAM}"
				;;
		esac
	done

	SOURCE_DIR="${SOURCE_DIR}" TARGET_DIR="${TARGET_DIR}" SETUP__GIT_LINK_TO_PROJECTS || {
		WARNING "failed to link '${TARGET_DIR}'"
	}

	return 0
}

SETUP__GIT__LINK_TO_PROJECTS() {
	[ "${TARGET_DIR}" ] && [ "${SOURCE_DIR}" ] \
		|| return 1

	{
		mkdir -p "${TARGET_DIR}"
		rm "${TARGET_DIR}/code"
		ln -s "${SOURCE_DIR}" "${TARGET_DIR}/code"
	} &>/dev/null
}
