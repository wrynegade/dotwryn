[ ! $PREFIX_ERR ] && PREFIX_ERR='ERROR  '
[ ! $PREFIX_FAT ] && PREFIX_FAT='FATAL  '
[ ! $PREFIX_WRN ] && PREFIX_WRN='WARNING'
[ ! $PREFIX_SCS ] && PREFIX_SCS='SUCCESS'
[ ! $PREFIX_STS ] && PREFIX_STS='STATUS '
[ ! $PREFIX_USR ] && PREFIX_USR='USER   '
[ ! $PREFIX_BLK ] && PREFIX_BLK='       '
[ ! $PREFIX_CHK ] && PREFIX_CHK='CHECK  '

function CONSOLE_COLOR_OUT() {
	local color="$1"
	local prefix="$2"

	local message="\\033[$color""m$prefix :: ${@:3}\\033[0m"

	[ ! $SINGLE_LINE ] && message="$message\n"

	printf $message
}
