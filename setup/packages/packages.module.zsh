#####################################################################

for setup_library in "${0:a:h}"/*.zsh
do
	case "${setup_library:t}" in
		( packages.module.zsh | dependency.manifest.zsh ) ;;  # self; manifest
		( * ) source "${setup_library}" ;;
	esac
done
unset setup_library

#####################################################################

setup.packages() {
	local INSTALLER="$(setup.packages.get-installer)"
	[[ "${INSTALLER}" ]] || return 1

	case "${INSTALLER}" in
		( brew | generic ) ;;  # homebrew refuses to run as root; generic installs nothing
		( * ) utils.io.getsudo ;;
	esac

	if (( ${+functions[setup.packages.installer.${INSTALLER}.setup-package-manager]} ))
	then
		"setup.packages.installer.${INSTALLER}.setup-package-manager" || return 2
	fi

	setup.packages.install-dependencies || return 3
}
