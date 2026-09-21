#####################################################################

setup.packages.install-from-source() {  # clone + build/install a git-hosted package (AUR PKGBUILD or Makefile)
	local target_url="${1}"
	local name="${2:-$(echo "${target_url}" | sed 's/.*\///; s/\.git$//')}"
	local install_dir="${HOME}/.local/share/source-packages"
	local package_dir="${install_dir}/${name}"
	mkdir -p -- "${install_dir}"

	local state=missing
	[[ -d "${package_dir}" ]] && state=exists

	case "${state}" in
		( exists )
			: \
				&& echo.status "updating '${name}'" \
				&& git -C "${package_dir}" pull origin "$(git -C "${package_dir}" rev-parse --abbrev-ref HEAD)" \
				;
			;;
		( missing )
			: \
				&& echo.status "downloading '${name}'" \
				&& git clone -- "${target_url}" "${package_dir}" \
				;
			;;
	esac \
		|| echo.error "failed to fetch '${name}'" \
		|| return 1

	local build_method=unknown
	[[ -f "${package_dir}/PKGBUILD" ]] && build_method=makepkg
	[[ -f "${package_dir}/Makefile" ]] && [[ "${build_method}" == unknown ]] && build_method=make

	case "${build_method}" in
		( makepkg )
			: \
				&& echo.status "installing '${name}'" \
				&& ( cd -- "${package_dir}" && yes | makepkg -si ) \
				&& echo.success "successfully installed '${name}'" \
				|| echo.error "failed to install '${name}'" \
				;
			;;
		( make )
			: \
				&& echo.status "building '${name}'" \
				&& make -C "${package_dir}" \
				&& : \
				&& echo.status "installing '${name}'" \
				&& utils.io.getsudo \
				&& sudo make -C "${package_dir}" install \
				&& echo.success "successfully installed '${name}'" \
				|| echo.error "failed to build/install '${name}'" \
				;
			;;
		( unknown )
			echo.warning 'could not detect supported installation method'
			echo.reminder 'complete manual installation in the directory below:'
			echo.reminder "${package_dir}"
			;;
	esac
}
