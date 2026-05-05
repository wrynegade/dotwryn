#####################################################################

use --group media youtube/yt-dlp

#####################################################################

${scwryptsmodule}() {
	media.youtube.yt-dlp --dump-json $@ \
		| jq -r '._filename' \
		| sed 's/\.[^.]*$/\.mp4/' \
		;
}
