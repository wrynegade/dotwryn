#####################################################################

setup.filesystem.write-managed-block() {
	# replaces (or appends) a dotwryn-managed block in a file, taking the
	# block body from stdin, so that every run refreshes the block rather
	# than appending another copy of it
	#
	# callers should use a "<<-" heredoc: it strips leading TABS (letting
	# the body stay indented with its caller) but leaves SPACES alone, so
	# indent the block's own nesting with spaces to keep it in the output
	#
	# "--one-line" trades the begin/end banner for a trailing comment on
	# the line itself, which suits a one-line entry like an rc source
	local file tag
	local comment='#'
	local one_line=false

	local _s _p
	while [[ "${#}" -gt 0 ]]
	do
		_s=1
		case "${1}" in
			( --comment ) _s=2
				comment="${2}"
				;;
			( --tag ) _s=2
				tag="${2}"
				;;
			( --one-line )
				one_line=true
				;;
			( * )
				case "$((_p+=1))" in
					( 1 ) file="${1}" ;;
					( * ) echo.error "write-managed-block: unexpected argument '${1}'" ;;
				esac
				;;
		esac
		shift "${_s}"
	done
	unset _s _p

	[[ "${file}" ]] \
		|| echo.error 'write-managed-block: no file given' \
		|| return 1

	# a single file can carry several managed blocks, so each one has to be
	# named to know which of them it owns
	[[ "${tag}" ]] \
		|| echo.error "write-managed-block: no --tag given for '${file}'" \
		|| return 1

	local body="$(cat)"

	[[ "${one_line}" == false ]] || [[ "${body}" != *$'\n'* ]] \
		|| echo.error "write-managed-block: --one-line needs a single-line body for '${file}'" \
		|| return 1

	mkdir -p -- "${file:h}"
	touch -- "${file}"

	local -a lines block
	lines=("${(@f)$(<"${file}")}")
	[[ -s "${file}" ]] || lines=()

	# an existing block is replaced where it sits, so anything the user
	# wrote around it keeps its position
	local begin_index end_index
	case "${one_line}" in
		( true )
			local marker="${comment} managed by dotwryn setup (${tag})"
			block=("${body}  ${marker}")

			# "(b)" keeps the tag's parentheses literal rather than glob
			begin_index="${lines[(i)*${(b)marker}]}"
			end_index="${begin_index}"
			;;
		( false )
			local begin="${comment} >>> managed by dotwryn setup (${tag}) >>>"
			local end="${comment} <<< managed by dotwryn setup (${tag}) <<<"
			block=("${begin}" "${(@f)body}" "${end}")

			begin_index="${lines[(ie)${begin}]}"
			end_index="${lines[(ie)${end}]}"
			[[ "${end_index}" -le "${#lines[@]}" ]] || end_index="${#lines[@]}"
			;;
	esac

	if [[ "${begin_index}" -gt "${#lines[@]}" ]]
	then
		lines+=("${block[@]}")
	else
		lines=(
			"${lines[@]:0:$((begin_index - 1))}"
			"${block[@]}"
			"${lines[@]:${end_index}}"
			)
	fi

	print -l -- "${lines[@]}" > "${file}"
}
