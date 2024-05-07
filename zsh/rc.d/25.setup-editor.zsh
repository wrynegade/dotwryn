() {  # set EDITOR/VISUAL variables
	[[ ${#PREFERRED_EDITORS[@]} -eq 0 ]] && {
		echo 'unable to find $PREFERRED_EDITORS environment variable'
		return 1
	}

	local PROGRAM PROGRAM_EXECUTABLE
	for PROGRAM in ${PREFERRED_EDITORS[@]}
	do
		PROGRAM_EXECUTABLE="$(which $PROGRAM 2>/dev/null)"
		[ -f "$PROGRAM_EXECUTABLE" ] \
			&& export EDITOR="$PROGRAM_EXECUTABLE" \
			&& export VISUAL="$PROGRAM_EXECUTABLE" \
			&& break
	done
}
