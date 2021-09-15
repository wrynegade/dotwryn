function CHECK() {
	SINGLE_LINE=1 CONSOLE_COLOR_OUT $WHITE $PREFIX_CHK $@'... '
}

function CHECK_RESULT() {
	local color="$1"
	local output="$2"
	printf "\\033[$color""m$output\\033[0m\n"
}

function OK()   {
	CHECK_RESULT $LIGHT_GREEN '✔ OK'
	[ $1 ] && SUCCESS $@
	return 0
}

function WARN() {
	CHECK_RESULT $YELLOW '⚠ WARN'
	[ $1 ] && WARNING $@
	return 0
}

function FAIL() {
	CHECK_RESULT $LIGHT_RED '✖ FAIL'
	FATAL $@
}
