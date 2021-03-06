#!/bin/bash

# $1 - path to folder
# $2 - angle 
# $3 - mapillary username

path=$(realpath $1)
capture_date=$2
echo $capture_date

for video in $path/*.MP4
do

	duration_seconds=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
	#do no put space here

	duration_seconds_int=${duration_seconds%.*}

	seq  0 $duration_seconds_int | parallel --bar  bash extract_frame.sh $video $capture_date {} 


done
video_dir=$(dirname "$video") 
find $video_dir -name "*.JPG"  | xargs basename --multiple | parallel --bar  bash ./filename2date.sh $video_dir/{} $capture_date
