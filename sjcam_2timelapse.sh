#!/bin/bash

# $1 - path to MP4 folder 
video_dir=$(realpath $1)


mkdir $video_dir/frames
for video in $video_dir/*.MP4
do
    video_nopath=${video##*/}
    video_noext="${video_nopath%.*}"


    ffmpeg -y -i $video -c copy -video_track_timescale 90k -an $video_dir/frames/$video_noext-tmp.mp4
    ffmpeg -y -itsscale 0.1 -i  $video_dir/frames/$video_noext-tmp.mp4  -c copy -an $video_dir/frames/$video_noext-spd.mp4
    rm -f $video_dir/frames/$video_noext-tmp.mp4

#    duration_frames=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1  $video)
#    echo $duration_frames
    #
    #set -B
#    clear
#    seq  0 $duration_frames | parallel --bar  ffmpeg  -y   -i $video  -vf select={}  -frames:v 1 $video_dir/frames/$video_noext_{}.PNG 
    #set +B
done


rm -f $video_dir/_tmp_filelist.txt
for video in $video_dir/frames/*spd.mp4
do
    echo "file '$video'" >> $video_dir/_tmp_filelist.txt
done



#ls -d  $video_dir/frames | sed "s/^/file '/g; s/$/'/g" > $video_dir/_tmp_filelist.txt

mkdir $video_dir/speeded
ffmpeg -f concat -safe 0 -i $video_dir/_tmp_filelist.txt -c copy $video_dir/speeded/$video_noext-speeded.mp4

rm -f $video_dir/_tmp_filelist.txt

#ffmpeg -y -f concat -safe 0 -i <(for f in $video_dir/frames/*spd*.mp4; do echo "file '$video_dir/frames/$f'"; done) -c copy $video_dir/frames/$video_noext-speeded.mp4

#-loglevel panic
rm -rf $video_dir/frames
