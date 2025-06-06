# cloned projects will be nested under the specified directories,
# allowing for meaningful project grouping. A friendly name is
# derived from the path
#
# e.g. "$HOME/Projects/GitHub" will be called "GitHub" in the CLI
#
# directories must be fully-qualified

CA__DIRS=()

#####################################################################

__BASE_DIR="$(readlink -f -- "${XDG_DATA_HOME:-${HOME}/.local/share}/project-source-code")"

[ "${__BASE_DIR}" ] && {
	[ -d "${HOME}/Projects" ] && mv "${HOME}/Projects" "${__BASE_DIR}"  # TODO : remove after everyone is moved to xdg home
	[ -d "${__BASE_DIR}" ] || mkdir -p -- "${__BASE_DIR}"

	for __PROJECT_GROUP in \
		brown-bag \
		gizmos \
		open-source \
		python \
		yage \
		zsh \
		;
	do
		mkdir -p "${__BASE_DIR}/${__PROJECT_GROUP}"
	done

	CA__DIRS+=($(find "${__BASE_DIR}" -mindepth 1 -maxdepth 1 -type d | sed 's/\/$//'))
}

unset __BASE_DIR

#####################################################################

# additional cloning targets; MUST END IN ':' or '/'
#    e.g. 'git@my.githost.com:' or 'git@github.com:w0ryn/'
CA__KNOWN_TARGETS=(
	'git@yage.io:brown-bag/'
	'git@yage.io:gizmos/'
	'git@yage.io:python/'
	'git@yage.io:wrynegade/'
	'git@github.com:wrynegade/'
	'https://yage.io/'
	'https://github.com/'
	'https://bitbucket.org/'
	'git@bitbucket.org:wrynegade/'
	)


# run from the specified hot-key
CA__SHORTCUT=' ' # CTRL+SPACE

# run from the specified alias
CA__ALIAS='lkj'


# enable / disable the shortcut / alias
# 0 = enabled   1 = disabled
CA__DISABLE_SHORTCUT=0 
CA__DISABLE_ALIAS=1


# structure options
# 
# where LOCAL_PROJECT_NAME is provided through the API / CLI, 
# the plugin will attempt to create the following structure:
#
# LOCAL_PROJECT_NAME
#     | SOURCE_DIR  << cloned repository
#     | VIRTUAL_ENV << the project's virtual environment
#     | CUSTOM_ENV  << CODE_ACTIVATOR's custom environment variables file
#     | NO_ENV      << CODE_ACTIVATOR sentinel to avoid prompting env setup
CA__SOURCE_DIR='code'
CA__VIRTUAL_ENV='env'
CA__CUSTOM_ENV='custom-env'
CA__NO_ENV='no-env'
