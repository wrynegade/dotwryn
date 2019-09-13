augroup rent_dynamics
	autocmd!
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*      setlocal expandtab
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*      let g:ycm_auto_trigger=1
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.cs   setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.ts*  setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */RentDynamics/*.scss setlocal tabstop=2 softtabstop=2 shiftwidth=2

	autocmd BufRead,BufEnter,BufNewFile */lead-mgmt-api-v1/*        setlocal expandtab
	autocmd BufRead,BufEnter,BufNewFile */lead-mgmt-api-v1/*.cs     setlocal tabstop=2 softtabstop=2 shiftwidth=2
	autocmd BufRead,BufEnter,BufNewFile */lead-mgmt-api-v1/*.cshtml setlocal tabstop=2 softtabstop=2 shiftwidth=2 filetype=html

	autocmd BufRead,BufNewFile */RentDynamics/* setlocal foldmethod=indent foldlevel=99
augroup end
