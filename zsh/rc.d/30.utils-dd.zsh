command -v dd &>/dev/null || return 0

utils.dd() {
	local ARGS=()

	# "byte size" dd default is 512-bytes, but 4M is modern sweet spot
	local bs=4M

	# show the progress bar (I can never remember to include this)
	local status=progress

	# By default, dd goes through kernel write cache which means dd could
	# report "Done" but the kernel is still flushing data to the USB in
	# the background. Disconnecting the USB drive at that point will
	# corrupt the image
	#
	# synchronous mosde is slower, but forces each write to hit the
	# physical device before dd moves on to the next block
	#
	# tl;dr "synchronous" mode = Done means Done
	local oflag=sync

	local _S
	while [[ ${#} -gt 0 ]]
	do
		_S=1
		case ${1} in
			( bs=*     ) bs=''     ; ARGS+=(${1}) ;;
			( status=* ) status='' ; ARGS+=(${1}) ;;
			( oflag=*  ) oflag=''  ; ARGS+=(${1}) ;;
			( *        )             ARGS+=(${1}) ;;
		esac

		shift ${_S} || {
			echo "ERROR missing argument for '${1}'"
			return 1
		}
	done

	local my_default
	for my_default in bs status oflag
	do
		[ "${(P)my_default}" ] && ARGS+=("${my_default}=${(P)my_default}")
	done

	dd ${ARGS[@]}
}
