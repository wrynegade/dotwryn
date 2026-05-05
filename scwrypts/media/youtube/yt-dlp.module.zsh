#####################################################################

use --group media youtube/get-download-path

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
