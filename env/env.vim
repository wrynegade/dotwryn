" -- RC Resources ----------------------------------------------- {{{
let $RC_DIR=expand("$HOME/.wryn")
let $VIM_DIR=expand("$RC_DIR/vim")
let $WRYNVIMRC=expand("$VIM_DIR/rc.vim")
let $WRYNBASH=expand("$RC_DIR/bashrc")
let $MYBASHRC=expand("$HOME/.bashrc")
" }}}


" -- Colorscheme Settings --------------------------------------- {{{
" favorites : tigrana-256-dark, codedark, lilydjwg_dark, up, skittles_autumn,
" ........... vice, lanox, nightsky, made_of_code, moss, skittles_berry, pf_earth
"
" customs   : snow
let $COLORSCHEME="skittles_autumn"
" }}}


" -- Local Environment Overrides -------------------------------- {{{
source $HOME/.config/wryn/env.vim
" }}}
