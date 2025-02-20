${scwryptsmodule}() {
	# local ACTION
	local PARSED=0

	case $1 in
		( --action )
			PARSED=2
			ACTION="$2"
			;;
	esac

	return $PARSED
}

#####################################################################

${scwryptsmodule}.usage() {
	USAGE__options+="
		--action <string>   a media sync action:
		                       push
		                       pull
		                       push-first-synchronize
		                       pull-first-synchronize
	"
}

${scwryptsmodule}.validate() {
	case "${ACTION}" in
		( push | pull | pull-first-synchronize | push-first-synchronize ) ;;
		( '' )
			ERROR 'must specify a media sync action'
			;;
		( * )
			ERROR "invalid media sync action '${ACTION}'"
			;;
	esac
}
