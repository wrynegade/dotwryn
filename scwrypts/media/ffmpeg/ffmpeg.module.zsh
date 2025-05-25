#
# personal ffmpeg utility since I don't use ffmpeg much and don't
# want to read the man every time
#

DEPENDENCIES+=(ffmpeg)

use ffmpeg/get-audio-clip-from-video --group media
use ffmpeg/get-video-length-seconds --group media
