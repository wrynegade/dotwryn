#####################################################################

use office/vim/config --group dotwryn

#####################################################################

${scwryptsmodule}() {
	find "$(config.vim.get-plugin-dir)" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
		| grep -v '^[Vv]undle\.vim$' \
		;
}
