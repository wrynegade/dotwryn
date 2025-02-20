#####################################################################

use youtube/yt-dlp --group media

#####################################################################

${scwryptsmodule}() {
	media.youtube.yt-dlp --dump-json $@ \
		| jq -r '._filename' \
		| sed 's/\.[^.]*$/\.mp4/' \
		;
}
