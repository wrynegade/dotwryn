#####################################################################

use system/zshparse --group dotwryn

DEPENDENCIES+=(tic)

#####################################################################

${scwryptsmodule}() {
	local PARSERS=(dotwryn.system.zshparse.dry-run)
	eval "$(utils.parse.autosetup)"
	##########################################
	local TERMINFO_FILE TERMINFO_FILE_COUNT
	for TERMINFO_FILE in $(find "${TERMINFO_PATH}" -type f)
	do
		((TERMINFO_FILE_COUNT+=1))
		case ${DRY_RUN} in
			( true )
				echo "tic -x \"${TERMINFO_FILE}\""
				;;
			( false )
				tic -x $TERMINFO_FILE >/dev/null 2>&1 \
					&& echo.success "added '$(basename $TERMINFO_FILE)'" \
					|| echo.error "failed to add '$(basename $TERMINFO_FILE)'" \
					;
				;;
		esac
	done

	case ${DRY_RUN} in
		( true )
			echo.success "detected ${TERMINFO_FILE_COUNT} terminal description(s)"
			;;
		( false )
			[[ ${ERRORS} -eq 0 ]] \
				&& echo.success "successfully compiled ${TERMINFO_FILE_COUNT} / ${TERMINFO_FILE_COUNT} terminal description(s)" \
				|| echo.error   "failed to compile ${ERRORS} / ${TERMINFO_FILE_COUNT} terminal description(s)" \
				;
			;;
	esac
}

#####################################################################

${scwryptsmodule}.parse() { return 0; }

${scwryptsmodule}.parse.locals() {
	local TERMINFO_PATH="${DOTWRYN}/config/terminfo"
}

${scwryptsmodule}.parse.usage() {
	USAGE__description='
		compiles source-controlled terminal descriptions
	'
}

${scwryptsmodule}.parse.validate() {
	[ -d "$TERMINFO_PATH" ] \
		|| echo.error "TERMINFO_PATH='$TERMINFO_PATH' does not exist"
}
