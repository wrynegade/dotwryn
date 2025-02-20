command -v \
		echo.error \
		echo.status \
		echo.success \
		echo.success.color \
		rg \
		sed \
		utils.check-errors \
		utils.colors.green \
		utils.yN \
	&>/dev/null || return 0


frog() {
	eval "$(usage.reset)"

	local USAGE__description='
		find-and-replace for all files in the current directory

		  frog = [F]ix [R]ip[G]rep ... and "o" because 🐸
	'

	local USAGE__options='
		-s, --search  <sed regex>   the regex to search for
		-r, --replace <string>      replacement value

		-d, --delete   delete instead having a replacement value
		    --trim     trim trailing spaces from all files in the work-tree

		-h, --help   print this message
	'

	local USAGE__args='
		\$1   search regex
		\$2   replacement value
	'

	local SEARCH_REGEX REPLACE_VALUE DELETE=false TRIM=false

	local _S ERRORS=0 POSITIONAL_ARGUMENT_COUNT=0
	while [[ $# -gt 0 ]]
	do
		_S=1

		case $1 in
			( -s | --search )
				_S=2
				SEARCH_REGEX="$2"
				;;

			( -r | --replace )
				_S=2
				REPLACE_VALUE="$2"
				;;

			( -d | --delete )
				_S=1
				DELETE=true
				;;

			( --trim )
				_S=1
				TRIM=true
				DELETE=true
				SEARCH_REGEX='\s+$'
				;;

			( -h | --help )
				utils.io.usage
				return 0
				;;

			( * )
				((POSITIONAL_ARGUMENT_COUNT+=1))
				case ${POSITIONAL_ARGUMENT_COUNT} in
					( 1 )
						case "${SEARCH_REGEX}" in
							( '' )
								SEARCH_REGEX="$1"
								;;
							( * )
								[ ! "${REPLACE_VALUE}" ] \
									&& REPLACE_VALUE="$1" \
									|| echo.error "too many arguments" \
									;
								;;
						esac
						;;

					( 2 )
						[ ! "${REPLACE_VALUE}" ] \
							&& REPLACE_VALUE="$1" \
							|| echo.error "too many arguments" \
							;
						;;

					( * )
						echo.error "unknown argument '$1'"
						;;
				esac
				;;
		esac

		[[ ${_S} -le $# ]] \
			&& shift ${_S} \
			|| echo.error "argument error for '$1'" \
			|| shift $#
	done

	[ ! "${SEARCH_REGEX}" ] && [ ! "${REPLACE_VALUE}" ] && [[ ${DELETE} =~ false ]] && [[ ${POSITIONAL_ARGUMENT_COUNT} -eq 0 ]] \
		&& utils.io.usage \
		&& return 0 \
		;

	[ "${SEARCH_REGEX}" ] \
		|| echo.error "missing search regex"

	[ ! "${REPLACE_VALUE}" ] && [[ ${DELETE} =~ false ]] \
		&& echo.error "missing replacement value"

	[ "${REPLACE_VALUE}" ] && [[ ${DELETE} =~ true ]] \
		&& echo.error "cannot use '--delete' with a replacement value"

	utils.check-errors || return $?

	##########################################

	local FILES_MATCHED=($(rg -l -- "${SEARCH_REGEX}"))
	[[ ${#FILES_MATCHED[@]} -gt 0 ]] || {
		echo.status "no files contain '${SEARCH_REGEX}' in the current tree; nothing to do"
		return 0
	}

	clear

	rg -- "${SEARCH_REGEX}" ${FILES_MATCHED[@]}

	echo.status "showing matches from $(utils.colors.green)${#FILES_MATCHED[@]} file(s)$(echo.status.color) in the current directory"
	utils.yN "replace all matches with '${REPLACE_VALUE}'?" || return 1

	[[ ${TRIM} =~ true ]] && SEARCH_REGEX='\s\+$'

	local FILENAME
	for FILENAME in ${FILES_MATCHED[@]}
	do
		sed -i "s${SEARCH_REGEX}${REPLACE_VALUE}g" "${FILENAME}" \
			|| echo.error "failed to update '${FILENAME}'"
	done

	[[ ${ERRORS} -eq 0 ]] \
		&& echo.success "successfully replaced '${SEARCH_REGEX}' with '${REPLACE_VALUE}'" \
		|| echo.error   "something went wrong (see above)" \
		;
}
