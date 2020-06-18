#!/bin/bash

# $1 - path to MP4 folder 
video_dir=$(realpath $1)

mkdir $video_dir/frames
for video in $video_dir/*.MP4
do
    duration_frames=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1  $video)
    echo $duration_frames
    #
    seq  0 $duration_frames | parallel --bar  ffmpeg -y -loglevel panic -vf select="between(n\,{}\,{}+1),setpts=PTS-STARTPTS" -i $1   -frames:v 1 $video_dir/frames/$video.{}.JPG 
done

#rm -rf $video_dir/frames
