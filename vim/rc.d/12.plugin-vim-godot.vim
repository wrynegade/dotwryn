if g:plugins_ok != 1 | finish | endif
" -------------------------------------------------------------------

" --- language server ----------------------

" note: YCM is pointing at 6015 instead of 6005; see ../../config/bin/godot-lsp-proxy.py
let g:ycm_language_server += [
			\ {
			\	'name': 'godot',
			\   'filetypes': [ 'gdscript' ],
			\   'project_root_files': [ 'project.godot' ],
			\   'port': 6015,
			\ }
			\ ]

" --- linter (gdlint) ----------------------

let g:ale_linters['gdscript'] = ['gdlint']

function! GdlintHandle(buffer, lines) abort
	let l:pattern = '\v^[^:]+:(\d+): (Error|Warning): (.+) \(([^)]+)\)$'
	let l:output = []

	for l:match in ale#util#GetMatches(a:lines, l:pattern)
		call add(l:output, {
					\   'lnum': l:match[1] + 0,
					\   'type': l:match[2] ==# 'Error' ? 'E' : 'W',
					\   'text': l:match[3] . ' [' . l:match[4] . ']',
					\})
	endfor

	return l:output
endfunction

call ale#linter#Define('gdscript', {
			\ 'name': 'gdlint',
			\ 'executable': 'gdlint',
			\ 'cwd': '%s:h',
			\ 'command': 'gdlint %s',
			\ 'callback': function('GdlintHandle'),
			\ 'output_stream': 'stderr',
			\})


" --- formatter (gdformat) -----------------

function! GdformatFix(buffer) abort
	return { 'command': 'gdformat -' }
endfunction

let g:ale_fixers['gdscript'] = [function('GdformatFix')]

call ale#Set('gdscript_gdformat_executable', 'gdformat')
