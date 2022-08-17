set termguicolors

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set t_Co=256

silent! colorscheme dim

highlight Normal     guibg=NONE ctermbg=NONE
highlight SpellBad   guibg=NONE guifg=red    ctermbg=NONE ctermfg=red
highlight LineNr     guibg=NONE guifg=purple ctermbg=NONE ctermfg=yellow
highlight SignColumn guibg=NONE              ctermbg=NONE
