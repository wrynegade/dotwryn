#####################################################################

${scwryptsmodule}.dry-run() {
	local PARSED=0

	case $1 in
		( --dry-run ) PARSED=1; DRY_RUN=true ;;
	esac

	return ${PARSED}
}

${scwryptsmodule}.dry-run.locals() {
	local DRY_RUN=false
}


${scwryptsmodule}.dry-run.usage() {
	USAGE__options+="
		--dry-run   output the commands that will be run, but don't perform any
		            actions on the filesystem
	"
}

#####################################################################
