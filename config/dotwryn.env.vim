" -- RC Resources ----------------------------------------------- {{{
if empty($DOTWRYN)
	let $DOTWRYN=expand("$HOME/.wryn")
endif
let $WRYNVIMPATH=expand("$DOTWRYN/vim")
let $WRYNVIMRC=expand("$WRYNVIMPATH/rc.vim")
" }}}

" -- Leader bindings -------------------------------------------- {{{
let mapleader = "\\"

nmap <BS> <Nop>
let maplocalleader = "\<BS>"
" }}}
