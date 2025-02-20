#####################################################################

use youtube/get-download-path --group media

#####################################################################

DEPENDENCIES+=(yt-dlp)
${scwryptsmodule}() {
	(
		cd -- "$(media.youtube.get-download-path)"
		yt-dlp \
			--restrict-filenames \
			$@
	)
}
