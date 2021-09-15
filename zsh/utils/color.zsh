#!/bin/zsh
[ ! $COLOR_PATH ] && COLOR_PATH="${0:a:h}/color"

# use colors by name
source "$COLOR_PATH/names.zsh"


# console message helper function
source "$COLOR_PATH/console-color-out.zsh" 


# write full line messages with semantic name
# e.g. 'ERROR : something bad happened' (in red)
source "$COLOR_PATH/messages.zsh" 


# two-piece message, check message >> run some stuff >> status
# the status appears on the same line as the check
#
# e.g. 'CHECK : installing something... ✔ OK'
source "$COLOR_PATH/check.zsh" 
