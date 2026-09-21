#####################################################################

setup.packages.get-installer() {
	# keyed on the package manager rather than the distro, so derivatives
	# (manjaro, endeavouros, mint, ...) work without being enumerated; yay
	# and brew are detected by their BASE manager since setup bootstraps
	# them itself when missing
	command -v pacman  &>/dev/null && echo yay     && return 0
	command -v dnf     &>/dev/null && echo dnf     && return 0
	command -v apt-get &>/dev/null && echo apt-get && return 0
	command -v brew    &>/dev/null && echo brew    && return 0

	[[ "$(uname -s)" == Darwin ]] && echo brew && return 0

	echo generic
}

#####################################################################

typeset -gA DEPENDENCY
DEPENDENCY_NAMES=()

dependency() {  # declare a dependency; flags may appear in any order relative to the name; see dependency.manifest.zsh for usage
	# dependency_args=(...), when set, is prepended to every call until reassigned
	# or unset -- lets a block of dependencies share flags without repeating them
	local -a args
	(( ${+dependency_args} )) && args=("${dependency_args[@]}" "${@}") || args=("${@}")

	local name installed_by yay dnf apt_get brew not_on only_on
	local no_executable=false
	local _s _p
	while [[ "${#args[@]}" -gt 0 ]]
	do
		_s=1
		case "${args[1]}" in
			( --installed-by  ) installed_by="${args[2]}"; _s=2 ;;
			( --yay           ) yay="${args[2]}";          _s=2 ;;
			( --dnf           ) dnf="${args[2]}";          _s=2 ;;
			( --apt-get       ) apt_get="${args[2]}";      _s=2 ;;
			( --brew          ) brew="${args[2]}";         _s=2 ;;
			( --not-on        ) not_on="${args[2]}";       _s=2 ;;
			( --only-on       ) only_on="${args[2]}";      _s=2 ;;
			( --no-executable ) no_executable=true ;;
			( -* )
				echo.error "dependency: unknown option '${args[1]}'"
				;;
			( * )
				case "$((_p+=1))" in
					( 1 ) name="${args[1]}" ;;
					( * ) echo.error "dependency: unexpected argument '${args[1]}'" ;;
				esac
				;;
		esac
		[[ "${#args[@]}" -ge "${_s}" ]] \
			&& args=("${args[@]:${_s}}") \
			|| echo.error "dependency: missing value for '${args[1]}'" \
			|| args=()
	done
	unset _s _p

	[[ -n "${name}" ]] \
		|| echo.error 'dependency: missing name' \
		|| return 1

	DEPENDENCY_NAMES+=("${name}")
	DEPENDENCY[${name}:installed-by]="${installed_by:-default}"
	DEPENDENCY[${name}:yay]="${yay:-${name}}"
	DEPENDENCY[${name}:dnf]="${dnf:-${name}}"
	DEPENDENCY[${name}:apt-get]="${apt_get:-${name}}"
	DEPENDENCY[${name}:brew]="${brew:-${name}}"
	DEPENDENCY[${name}:generic]="${name}"  # no override -- the dependency's own name IS the generic fallback
	DEPENDENCY[${name}:not-on]="${not_on:-}"
	DEPENDENCY[${name}:only-on]="${only_on:-}"
	DEPENDENCY[${name}:no-executable]="${no_executable}"
}

source "${0:a:h}/dependency.manifest.zsh"

#####################################################################

setup.packages.list-installation-profiles() {  # every profile named by an --installed-by in the manifest
	local name
	for name in "${DEPENDENCY_NAMES[@]}"
	do
		print -l -- "${(s:,:)DEPENDENCY[${name}:installed-by]}"
	done \
		| sort -u
}

setup.packages._.describe-package() {
	# a package name isn't always 1:1 with the dependency which asked for it
	# (e.g. yay's "base-devel" satisfies autoconf, automake, bison, ...), so
	# name the dependencies too whenever they differ from the package itself
	local package="${1}" dependency_names="${2}"
	local display="${package#cask:}"  # macOS casks carry a "cask:" prefix through the pipeline

	[[ "${dependency_names}" == "${display}" ]] \
		&& echo "'${display}'" \
		&& return 0

	echo "'${display}' (satisfies: ${dependency_names// /, })"
}

setup.packages.install-dependencies() {
	local ERRORS=0

	echo.status 'checking package dependencies'
	local installer="${INSTALLER:-$(setup.packages.get-installer)}"
	[[ "${installer}" != generic ]] \
		|| echo.warning 'no supported package manager detected; dependencies can only be verified, not installed'

	local requested_config="${DOTWRYN_SETUP__INSTALLATION_PROFILE:-default}"

	local name field target
	local -a targets
	local -A package_names       # resolved package -> space-joined logical dependency names
	local -a executable_names    # dependency names that must resolve via `command -v` (no-executable excluded)
	[[ "${#DOTWRYN_SETUP__EXCLUDE[@]}" -eq 0 ]] \
		|| echo.status "excluding dependencies: ${(j:, :)DOTWRYN_SETUP__EXCLUDE}"

	for name in "${DEPENDENCY_NAMES[@]}"
	do
		(( ${DOTWRYN_SETUP__EXCLUDE[(Ie)${name}]} )) && continue

		[[ ",${DEPENDENCY[${name}:installed-by]}," == *",${requested_config},"* ]] || continue

		field="${DEPENDENCY[${name}:only-on]}"
		[[ -n "${field}" ]] && [[ ",${field}," != *",${installer},"* ]] && continue

		field="${DEPENDENCY[${name}:not-on]}"
		[[ -n "${field}" ]] && [[ ",${field}," == *",${installer},"* ]] && continue

		[[ "${DEPENDENCY[${name}:no-executable]}" == false ]] && executable_names+=("${name}")

		field="${DEPENDENCY[${name}:${installer}]}"

		# a dependency can require more than one physical package on a given installer
		# (e.g. "docker" needing docker-ce, docker-ce-cli, and containerd.io on
		# dnf) -- each --<installer> flag accepts a comma-separated list of targets
		targets=("${(s:,:)field}")
		for target in "${targets[@]}"
		do
			package_names[${target}]+=" ${name}"
		done
	done
	unset name field target targets

	if [[ "${installer}" == generic ]]
	then
		for name in "${executable_names[@]}"
		do
			setup.packages.installer.generic.install-managed "${name}"
		done
		unset name
		echo.success 'all dependencies satisfied'
		return 0
	fi

	case "${CI}" in
		( true ) ;;  # no system to update
		( * )
			echo.status 'updating system, repositories, and mirrors'
			"setup.packages.installer.${installer}.update-repositories"
			;;
	esac

	local -a installed_packages
	installed_packages=("${(f)$("setup.packages.installer.${installer}.list-installed")}")

	local package
	local -a missing_packages
	for package in "${(k)package_names[@]}"
	do
		(( ${installed_packages[(Ie)${package}]} )) && continue
		missing_packages+=("${package}")
	done
	unset package

	if [[ "${#missing_packages[@]}" -eq 0 ]]
	then
		echo.success 'all dependencies satisfied'
	else
		for package in "${missing_packages[@]}"
		do
			echo.status "installing $(setup.packages._.describe-package "${package}" "${package_names[${package}]# }")"
		done
		unset package

		"setup.packages.installer.${installer}.install-batch" "${missing_packages[@]}"

		# don't trust the batch call's exit code alone: some package managers (yay in
		# particular) can exit 0 after silently skipping one unresolvable AUR target
		# rather than failing the whole transaction, so re-check what's actually installed
		installed_packages=("${(f)$("setup.packages.installer.${installer}.list-installed")}")

		local -a still_missing
		for package in "${missing_packages[@]}"
		do
			(( ${installed_packages[(Ie)${package}]} )) || still_missing+=("${package}")
		done

		[[ "${#still_missing[@]}" -gt 0 ]] \
			&& echo.warning 'batched install left some packages unresolved; retrying them one at a time to isolate the failure(s)'

		for package in "${missing_packages[@]}"
		do
			if [[ " ${still_missing[*]} " == *" ${package} "* ]]
			then
				"setup.packages.installer.${installer}.install-managed" "${package}"
			else
				echo.success "$(setup.packages._.describe-package "${package}" "${package_names[${package}]# }") installed"
			fi
		done
		unset package still_missing
	fi

	case "${installer}" in
		( brew )
			# especially important on macOS where BSD utilities are the default
			echo.status "making sure homebrew GNU utilities are default"

			local gnubin_path
			for gnubin_path in "$(brew --prefix)"/opt/*/libexec/gnubin(N); do export PATH="${gnubin_path}:${PATH}"; done
			unset gnubin_path

			setup.filesystem.write-managed-block "${HOME}/.zprofile" --tag homebrew <<-'EOF'
				# (homebrew required) : load homebrew shellenv
				eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"

				# ensure GNU utilities from homebrew load before system/BSD utils
				for homebrew_gnu_bin_path in "$(brew --prefix)"/opt/*/libexec/gnubin(N)
				do
				    export PATH="${homebrew_gnu_bin_path}:${PATH}"
				done
				unset homebrew_gnu_bin_path
			EOF
			;;
	esac

	echo.status 'verifying dependency executables'
	for name in "${executable_names[@]}"
	do
		command -v "${name}" &>/dev/null \
			|| echo.error "'${name}' is installed but its executable could not be found on PATH"
	done
	unset name

	if [[ "${ERRORS}" -ne 0 ]]
	then
		echo.warning "detected ${ERRORS} errors; double check warnings before proceeding!"
		case "${DOTWRYN_SETUP__STRICT}" in
			( true ) return 1 ;;  # never prompt; unresolved dependencies are a failure
			( * ) utils.yN 'continue with install?' || return 1 ;;
		esac
	fi

	echo.success 'all dependencies satisfied'
	return 0
}
