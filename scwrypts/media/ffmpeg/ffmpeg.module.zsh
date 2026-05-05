#
# personal ffmpeg utility since I don't use ffmpeg much and don't
# want to read the man every time
#

DEPENDENCIES+=(ffmpeg)

use --group media ffmpeg/get-audio-clip-from-video
use --group media ffmpeg/get-video-length-seconds
