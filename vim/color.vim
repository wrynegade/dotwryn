let &t_8f="\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b="\<Esc>[48:2:%lu:%lu:%lum"
set t_Co=256

colorscheme default
silent! colorscheme dim

highlight Normal      guibg=NONE ctermbg=NONE
highlight SignColumn  guibg=NONE ctermbg=NONE
highlight SpellBad    guibg=NONE ctermbg=NONE ctermfg=red
highlight LineNr      guibg=NONE ctermbg=NONE ctermfg=darkmagenta

highlight TabLineFill guibg=NONE ctermbg=NONE ctermfg=magenta
highlight TabLine     guibg=NONE ctermbg=NONE ctermfg=darkgray
highlight TabLineSel  guibg=NONE ctermbg=NONE ctermfg=white    term=bold
