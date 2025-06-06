set t_Co=256 t_8f=[38:2:%lu:%lu:%lum t_8b=[48:2:%lu:%lu:%lum t_ZH=[3m t_ZR=[23m t_Cs=[4:3m t_Ce=[4:0m

colorscheme default
silent! colorscheme dim

highlight Normal                                    ctermbg=NONE        guibg=NONE
highlight SignColumn                                ctermbg=NONE        guibg=NONE
highlight LineNr                                    ctermbg=NONE        guibg=NONE        ctermfg=darkmagenta guifg=darkmagenta

highlight SpellBad    cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE        ctermfg=red         guifg=red
highlight SpellCap    cterm=undercurl gui=undercurl ctermbg=NONE        guibg=NONE        ctermfg=darkred     guifg=darkred
highlight comment     cterm=NONE      gui=NONE      ctermbg=NONE        guibg=NONE        ctermfg=grey        guifg=grey

highlight TabLineFill cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE
highlight TabLine     cterm=NONE      gui=NONE      ctermbg=NONE        guibg=NONE        ctermfg=darkgray    guifg=darkgray
highlight TabLineSel  cterm=bold      gui=bold      ctermbg=NONE        guibg=NONE        ctermfg=white       guifg=white

highlight ALEVirtualTextError        cterm=nocombine,italic gui=nocombine,italic ctermbg=NONE ctermfg=yellow guibg=NONE guifg=yellow
highlight ALEVirtualTextWarning      cterm=nocombine,italic gui=nocombine,italic ctermbg=NONE ctermfg=yellow guibg=NONE guifg=yellow
highlight ALEVirtualTextInfo         cterm=nocombine,italic gui=nocombine,italic ctermbg=NONE ctermfg=yellow guibg=NONE guifg=yellow
highlight ALEVirtualTextStyleError   cterm=nocombine,italic gui=nocombine,italic ctermbg=NONE ctermfg=yellow guibg=NONE guifg=yellow
highlight ALEVirtualTextStyleWarning cterm=nocombine,italic gui=nocombine,italic ctermbg=NONE ctermfg=yellow guibg=NONE guifg=yellow
