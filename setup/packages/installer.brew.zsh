#####################################################################

setup.packages.installer.brew.setup-package-manager() {
	command -v brew &>/dev/null && return 0

	# an already-installed homebrew still isn't on PATH in a fresh login
	# shell, so adopt it before concluding it needs installing
	local brew_path
	for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew
	do
		[[ -x "${brew_path}" ]] || continue
		eval "$("${brew_path}" shellenv)"
		return 0
	done
	unset brew_path

	: \
		&& /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
		&& eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)" \
		|| echo.error 'failed to install homebrew' \
		|| return 1 \
	;
}

setup.packages.installer.brew.update-repositories() { brew update && brew upgrade; }

setup.packages.installer.brew.list-installed() {  # targets needing "brew install --cask" are carried through this whole pipeline as "cask:name"
	brew list --formula 2>/dev/null
	brew list --cask 2>/dev/null | sed 's/^/cask:/'
}

setup.packages.installer.brew.install-batch() {
	local -a formulae casks
	local target
	for target in "${@}"
	do
		case "${target}" in
			( cask:* ) casks+=("${target#cask:}") ;;
			( * )      formulae+=("${target}")    ;;
		esac
	done
	unset target

	if [[ "${#formulae[@]}" -gt 0 ]]
	then
		yes | brew install "${formulae[@]}" || return 1
	fi

	if [[ "${#casks[@]}" -gt 0 ]]
	then
		yes | brew install --cask "${casks[@]}" || return 2
	fi
}

setup.packages.installer.brew.install-managed() {
	local target="${1}"
	local -a cask_flag
	if [[ "${target}" == cask:* ]]
	then
		target="${target#cask:}"
		cask_flag=(--cask)
	fi

	if brew list "${cask_flag[@]}" --versions "${target}" &>/dev/null
	then
		echo.success "found '${target}'"
		return 0
	fi

	: \
		&& echo.status "installing '${target}'" \
		&& yes | brew install "${cask_flag[@]}" "${target}" \
		&& echo.success "'${target}' installed" \
		|| echo.error "failed to install '${target}'" \
		;
}
