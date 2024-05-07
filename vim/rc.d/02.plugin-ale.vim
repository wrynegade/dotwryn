if g:plugins_ok != 1 | finish | endif
" -------------------------------------------------------------------

let g:ale_linters = {
\ 'cs' : ['OmniSharp'],
\ 'python' : ['pylint'],
\ 'go' : ['golint'],
\ 'rust' : ['analyzer'],
\}

let g:ale_fixers = {
\ 'javascript': ['prettier'],
\ 'typescript': ['prettier'],
\ 'rust': ['rustfmt'],
\}

let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_sign_column_always = 1

nnoremap <Leader>at <Plug>(ale_toggle_buffer)
nnoremap <Leader>ae <Plug>(ale_next)
nnoremap <Leader>ad :YcmDiags<CR>  " requires 01.plugin-youcompleteme.vim
nnoremap <Leader>ar <Plug>(ale_previous)
nnoremap <Leader>f  <Plug>(ale_fix)
