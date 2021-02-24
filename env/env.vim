" -- RC Resources ----------------------------------------------- {{{
let $RC_DIR=expand("$HOME/.wryn")
let $VIM_DIR=expand("$RC_DIR/vim")
let $WRYNVIMRC=expand("$VIM_DIR/rc.vim")
let $BASHRC=expand("$HOME/.bashrc")
let $ZSHRC=expand("$HOME/.zshrc")
" }}}


" -- Colorscheme Settings --------------------------------------- {{{
" favorites : tigrana-256-dark, codedark, lilydjwg_dark, up, skittles_autumn,
" ........... vice, lanox, nightsky, made_of_code, moss, skittles_berry, pf_earth
"
" customs   : snow
let $COLORSCHEME="default"
" }}}

" -- Web Browser Settings --------------------------------------- {{{
" set the webbrowser locally
"let $WEBBROWSER=""
" }}}

" -- Local Environment Overrides -------------------------------- {{{
source $HOME/.config/wryn/env.vim
" }}}
