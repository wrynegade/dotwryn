augroup directus
	autocmd!
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.js  setlocal noexpandtab
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.mjs setlocal noexpandtab
	autocmd BufRead,BufEnter,BufNewFile */Projects/directus/*.ts  setlocal noexpandtab
augroup end
