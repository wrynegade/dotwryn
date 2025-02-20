#####################################################################

use youtube/yt-dlp --group media
use youtube/get-filename --group media
use youtube/get-download-path --group media

#####################################################################

${scwryptsmodule}() {
	eval "$(USAGE.reset)"

	local \
		URL INTERACTIVE=false \
		PARSERS=()

	eval "$ZSHPARSEARGS"

	##########################################

	local FILENAME="$(media.youtube.get-filename "${URL}")"

	[ "${FILENAME}" ] \
		|| ERROR "could not find metadata; cannot proceed with download\n${URL}" \
		|| return 1

	media.youtube.yt-dlp "${URL}" \
			--format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' \
		&& echo.success "finished download of ${URL}\n$(media.youtube.get-download-path)/${FILENAME}" \
		||   ERROR "failed to download '${FILENAME}' (${URL})"
		;
}

#####################################################################

${scwryptsmodule}.parse() {
	# local URL INTERACTIVE=false
	local PARSED=0

	case $1 in
		--url )
			PARSED=2
			URL="$2"
			;;

		--interactive )
			PARSED=1
			INTERACTIVE=true
			;;
	esac

	return $PARSED
}

${scwryptsmodule}.parse.usage() {
	USAGE__options+="
		--url <string>   the URL of the target video
	"
}

${scwryptsmodule}.parse.validate() {
	[ "$URL" ] \
		|| ERROR "must provide download URL"
}
