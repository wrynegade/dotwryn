#####################################################################

use office/vim/config --group dotwryn
use office/vim/vundle/build --group dotwryn

DEPENDENCIES+=(git)

#####################################################################

${scwryptsmodule}() {
	eval "$(utils.parse.autosetup)"
	##########################################
	
	local VIM_PLUGIN_DIR="$(config.vim.get-plugin-dir)"
	[ "${VIM_PLUGIN_DIR}" ] \
		|| echo.error "cannot determine vim plugin dir (see above)" \
		|| return 1

	local VUNDLE_DIR="${VIM_PLUGIN_DIR}/Vundle.vim"
	[ -d "${VUNDLE_DIR}" ] || {
		git clone https://github.com/VundleVim/Vundle.vim.git "${VUNDLE_DIR}" \
			|| echo.error "unable to install Vundle.vim" \
			|| return 2
	}

	utils.vim +PluginInstall +qall \
		&& echo.success 'successfully installed Vundle.vim plugins' \
		|| echo.error   'failed to install Vundle.vim plugins' \
		|| return 3

	dotwryn.office.vim.vundle.build \
		|| return 4
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }
${scwryptsmodule}.parse.usage() {
	USAGE__description='update / install Vundle.vim and vim plugins'
}
