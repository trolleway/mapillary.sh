#!/bin/bash

# $1 - path to MP4 folder 
path=$(realpath $1)

for video in $path/*.MP4
do
    duration_frames=$(ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 $video)
    echo $duration_frames
    #-vf select="between(n\,200\,300),setpts=PTS-STARTPTS"
done
