#####################################################################

setup.config.generate-initial-local-config() {
	local local_hostname="$(hostnamectl --static 2>/dev/null || hostname 2>/dev/null | sed 's/\.local$//')"
	[[ "${local_hostname}" ]] || return 0

	mkdir -p -- "${DOTWRYN_SETUP__DOTWRYN}/config/local/${local_hostname}/bin"

	local env_dir="${DOTWRYN_SETUP__DOTWRYN}/config/scwrypts/environments"
	local group
	for group in $(find "${env_dir}" -type f -name \*env.yaml | sed -n 's|.*/local\.\([^.]*\)\.env\.yaml|\1|p')
	do
		[[ -f "${env_dir}/local.${local_hostname}.${group}.env.yaml" ]] && continue

		cp -- "${env_dir}/local.${group}.env.yaml" "${env_dir}/local.${local_hostname}.${group}.env.yaml"
	done
	unset group

	local local_override
	for local_override in \
		hypr/local.lua \
		i3/local.yaml \
		polybar/local.ini \
		alacritty/local.toml \
		;
	do
		mkdir -p -- "${DOTWRYN_SETUP__DOTWRYN}/config/local/${local_hostname}/user/$(dirname -- "${local_override}")"
		touch -- "${DOTWRYN_SETUP__DOTWRYN}/config/local/${local_hostname}/user/${local_override}"
	done
	unset local_override
}
