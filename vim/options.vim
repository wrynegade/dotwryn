
set formatoptions=lj

set number relativenumber

set linebreak breakindent breakindentopt=shift:3
set autoindent smartindent

set timeoutlen=200

set showmatch   " -- emit 'beep' when no matching symbol,
set matchtime=0 " -- but don't jump to it.

set tabpagemax=20

set t_ZH=[3m t_ZR=[23m " italic start / end characters

set spellfile=$WRYNVIMPATH/en.utf-8.add spelllang=en

set encoding=utf-8

let &t_co=256
