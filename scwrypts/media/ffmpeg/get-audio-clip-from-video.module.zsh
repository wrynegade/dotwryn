#####################################################################

DEPENDENCIES+=(ffmpeg)

use ffmpeg/get-video-length-seconds --group media

#####################################################################

${scwryptsmodule}() {
	eval "$(USAGE.reset)"
	local USAGE__description='
		converts a video into an audio clip (mp3)

		if only --start is used, the audio clip will be from
		the specified start point to the end of the video

		if only --end is used, the audio clip will be from
		the start of the video to the specified end point

		if --start, --end, and --use-whole-video are all omitted,
		start and end times will be prompted interactively
	'

	local \
		INPUT_FILENAME OUTPUT_FILENAME \
		USE_WHOLE_VIDEO=false \
		START_TIME_SECONDS END_TIME_SECONDS \
		PARSERS=()

	eval "$ZSHPARSEARGS"

	##########################################

	echo.status "converting video to audio
	  video input  : ${INPUT_FILENAME}
	  audio output : ${OUTPUT_FILENAME}
	  start time   : ${START_TIME_SECONDS}
	    end time   : ${END_TIME_SECONDS}
	"

	ffmpeg -i "${INPUT_FILENAME}" -q:a 0 -map a \
		-ss ${START_TIME_SECONDS} -t $((${END_TIME_SECONDS} - ${START_TIME_SECONDS}))\
		"${OUTPUT_FILENAME}" \
		&& echo.success "created clip '${OUTPUT_FILENAME}'" \
		||   ERROR "error creating clip '$(basename -- "${OUTPUT_FILENAME}")' (see above)"
}

#####################################################################

${scwryptsmodule}.parse() {
	# local INPUT_FILENAME OUTPUT_FILENAME
	# local USE_WHOLE_VIDEO=false
	# local START_TIME_SECONDS END_TIME_SECONDS    optional

	local PARSED=0
	
	case $1 in
		-i | --input-filename  ) PARSED=2;  INPUT_FILENAME="$2" ;;
		-o | --output-filename ) PARSED=2; OUTPUT_FILENAME="$2" ;;

		--start ) PARSED=2; START_TIME_SECONDS="$2" ;;
		--end   ) PARSED=2;   END_TIME_SECONDS="$2" ;;

		--use-whole-video ) PARSED=1; USE_WHOLE_VIDEO=true ;;
	esac

	return $PARSED
}

${scwryptsmodule}.parse.usage() {
	USAGE__options='
		-i, --input-filename <string>    fully-qualified path to input file
		-o, --output-filename <string>   fully-qualified path to output file

		--start <seconds>   start time of the clip
		--end   <seconds>     end time of the clip

		--use-whole-video   convert whole video instead of just a portion
	'
}

${scwryptsmodule}.parse.validate() {
	: \
		&& [ "${INPUT_FILENAME}" ] \
		&& [ -f "${INPUT_FILENAME}" ] \
		&& [ "${OUTPUT_FILENAME}" ] \
		|| ERROR "must provide a valid input and output filename\ninput  : '${INPUT_FILENAME}\noutput : '${OUTPUT_FILENAME}'" \
		|| return

	[[ ${OUTPUT_FILENAME} =~ .mp3$ ]] || OUTPUT_FILENAME="${OUTPUT_FILENAME}.mp3"

	local VIDEO_LENGTH_SECONDS=$(media.ffmpeg.get-video-length-seconds "${INPUT_FILENAME}")
	[ "${VIDEO_LENGTH_SECONDS}" ] && [[ "${VIDEO_LENGTH_SECONDS}" -gt 0 ]] \
		|| ERROR "unable to determine video length; is '${INPUT_FILENAME}' a video?" \
		|| return

	local CLIP_METHOD=start-time-to-end-time
	case ${USE_WHOLE_VIDEO} in
		true )
			[ ! "${START_TIME_SECONDS}" ] \
				|| ERROR "conflicting arguments '--start' and '--use-whole-video'"

			[ ! "${END_TIME_SECONDS}" ] \
				|| ERROR "conflicting arguments '--end' and '--use-whole-video'"
			;;
		false )
			[ ! "${START_TIME_SECONDS}" ] && [ ! "${END_TIME_SECONDS}" ] \
				&& CLIP_METHOD=interactive
			;;
	esac

	case ${CLIP_METHOD} in
		start-time-to-end-time )
			[ "${START_TIME_SECONDS}" ] || START_TIME_SECONDS=0
			[ "${END_TIME_SECONDS}"   ] || END_TIME_SECONDS="${VIDEO_LENGTH_SECONDS}"
			;;

		interactive )
			START_TIME_SECONDS=$(echo 0 | utils.fzf.user-input "enter start time (0 ≤ t < ${VIDEO_LENGTH_SECONDS})")
			[ "${START_TIME_SECONDS}" ] \
				|| ERROR 'interactive user abort' \
				|| return

			END_TIME_SECONDS=$(echo ${VIDEO_LENGTH_SECONDS} | utils.fzf.user-input "enter end time (${START_TIME_SECONDS} > t ≥ $VIDEO_LENGTH_SECONDS)")
			[ "${END_TIME_SECONDS}" ] \
				|| ERROR 'interactive user abort' \
				|| return
			;;
	esac

	[[ "${START_TIME_SECONDS}" -ge 0 ]] \
		|| ERROR "cannot use negative start time (start time = ${START_TIME_SECONDS})"

	[[ "${END_TIME_SECONDS}" -gt 0 ]] \
		|| ERROR "end time must be after the video starts (end time = ${END_TIME_SECONDS})"

	[[ "${START_TIME_SECONDS}" -lt "${VIDEO_LENGTH_SECONDS}" ]] \
		|| ERROR "start time must be before video ends (start time = ${START_TIME_SECONDS}; video length = ${VIDEO_LENGTH_SECONDS})"

	[[ "${END_TIME_SECONDS}" -le "${VIDEO_LENGTH_SECONDS}" ]] \
		|| ERROR "end time cannot go beyond video end (end time = ${END_TIME_SECONDS}; video length = ${VIDEO_LENGTH_SECONDS})"

	[[ "${START_TIME_SECONDS}" -lt "${END_TIME_SECONDS}" ]] \
		|| ERROR "start time must come before end time (start time = ${START_TIME_SECONDS}; end time = ${END_TIME_SECONDS})"
}
