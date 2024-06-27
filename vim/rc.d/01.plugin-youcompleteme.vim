if g:plugins_ok != 1 | finish | endif
" -------------------------------------------------------------------

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_goto_buffer_command = 'new-tab'
let g:ycm_auto_hover = ''

let g:preferred_rust_root = trim(system("rustup toolchain list -v | grep default | sed 's|[^/]*||'"))

if isdirectory(g:preferred_rust_root)
       let g:ycm_rust_toolchain_root = g:preferred_rust_root
endif

function! ToggleYCM()
	if g:ycm_auto_trigger
		let g:ycm_auto_trigger = 0
		echohl DiffDelete | echo "YouCompleteMe autocompletion disabled" | echohl None
	else
		let g:ycm_auto_trigger = 1
		echohl DiffAdd | echo "YouCompleteMe autocompletion enabled" | echohl None
	endif
endfunction

nnoremap <S-y> :call ToggleYCM()<CR>
nnoremap gd :YcmCompleter GoToDefinition<CR>

augroup ycm_hover
       autocmd FileType rust,typescript,javascript,python nnoremap <silent><buffer> K <Plug>(YCMHover)
augroup end
