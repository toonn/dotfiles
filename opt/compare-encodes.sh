#! /bin/sh
ffmpeg -i $1  -i $2 -filter_complex vstack  -f yuv4mpegpipe - | mpv -
