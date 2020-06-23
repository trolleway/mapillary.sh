#!/bin/bash

# $1 - path to folder
# $2 - angle 

# RUN apt-cache policy tzdata
# RUN apt-get install except

usage() { printf "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary \n Usage: $0 [-u <mapillary username>] [-p <password>] [-a <offset angle>] [-s <source folder>]" 1>&2; exit 1; }



USERNAME="trolleway"
ANGLE="180"

#search first gpx file in folder
gpx=$(find $1 -name "*.gpx" |  head -n 1)
#offset_time=$((3*3600))
#echo $offset_time

#i can't fighred how to deal with timezones in mapillary_tools geotag_source, but exiftool seems work
echo 'geotag'
#find $1 -name "*.JPG" | parallel --bar exiftool -q -q -overwrite_original -geotag $gpx  {}

exiftool -progress -q -q -overwrite_original -geotag $gpx $1

mapillary_tools process --advanced --import_path "$1" --user_name $USERNAME --cutoff_distance 100 --cutoff_time 60 \
--interpolate_directions --offset_angle $2 --rerun --overwrite_EXIF_direction_tag 2> /dev/null  

mapillary_tools upload --import_path "$1" --skip_subfolders --number_threads 4 --max_attempts 50 --advanced
echo "End" 
  