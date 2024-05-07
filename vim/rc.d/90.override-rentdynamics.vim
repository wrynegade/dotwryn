augroup rent_dynamics
	autocmd!
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.cs     setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.ts*    setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.scss   setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.less   setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.css    setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.cshtml setlocal tabstop=2 softtabstop=2 shiftwidth=2 filetype=html

	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/leo-lead-mgmt/* setlocal tabstop=4 softtabstop=4 shiftwidth=4

	autocmd BufRead,BufNewFile */RentDynamics/* setlocal foldmethod=indent foldlevel=99
augroup end
