set t_Co=256 t_8f=[38:2:%lu:%lu:%lum t_8b=[48:2:%lu:%lu:%lum t_ZH=[3m t_ZR=[23m

colorscheme default
silent! colorscheme dim

highlight Normal                                    ctermbg=NONE        guibg=NONE
highlight SignColumn                                ctermbg=NONE        guibg=NONE
highlight LineNr                                    ctermbg=NONE        guibg=NONE        ctermfg=darkmagenta guifg=darkmagenta

highlight SpellBad    cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE        ctermfg=red         guifg=red

highlight TabLineFill cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE
highlight TabLine     cterm=NONE      gui=NONE      ctermbg=NONE        guibg=NONE        ctermfg=darkgray    guifg=darkgray
highlight TabLineSel  cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE        ctermfg=white       guifg=white
