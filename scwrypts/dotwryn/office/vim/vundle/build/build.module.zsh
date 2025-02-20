#####################################################################

use office/vim/config --group dotwryn
use office/vim/vundle/get-all --group dotwryn

#DEPENDENCIES+=()
#REQUIRED_ENV+=()

#####################################################################

${scwryptsmodule}() {
	eval "$(utils.parse.autosetup)"
	##########################################
	local ORIGINAL_DIR="$(pwd)"
	local VIM_PLUGIN_DIR="$(config.vim.get-plugin-dir)"

	local PLUGIN
	for PLUGIN in $(dotwryn.office.vim.vundle.get-all)
	do
		unset -f utils.vundle.build &>/dev/null

		case ${PLUGIN} in
			( vim-hexokinase )
				utils.vundle.build() {
					make hexokinase
				}
				;;

			( [yY]ou[cC]omplete[Mm]e )
				utils.vundle.build() {
					git submodule update --remote
					./install.py --all
				}
				;;

			( * )
				continue  # most plugins do not require build steps
				;;
		esac

		cd -- "${VIM_PLUGIN_DIR}/${PLUGIN}"

		echo.status "building '$PLUGIN'"
		utils.vundle.build \
			&& echo.success "finished building '$PLUGIN'" \
			|| echo.error "failed to build '$PLUGIN' (see above)" \
			;
	done

	[ "${ORIGINAL_DIR}" ] && cd -- "${ORIGINAL_DIR}"
	return $ERRORS
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }
${scwryptsmodule}.parse.usage() {
	USAGE__description='(re)build plugins based on defined steps'
}
