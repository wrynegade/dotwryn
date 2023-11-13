augroup directus
	autocmd!
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.js  setlocal noexpandtab
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.mjs setlocal noexpandtab
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.ts  setlocal noexpandtab

	autocmd BufRead,BufNewFile */Projects/directus/cloud/code/scwrypts/* let b:scwryptsAutoName = "directus " . b:scwryptsAutoName
augroup end
