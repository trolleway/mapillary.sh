#!/bin/bash

# $1 - path to SJCAM photos folder

# Originals are keep untouched
path=$1
mkdir $1/mapillary_copy

# SJCAM camera produce broken jpegs, some of them failed at Mapillary server. 
# Crop whth recompress to rebuild JPEG. Crop to 16:9
#get list of jpegs from folder, then strips path
find $1 -name "*.JPG" | xargs basename --multiple | parallel --bar convert  -crop 4002x2551+606+309 -quality 85% "$1/{}" "$1/mapillary_copy/{}"


mapillary_tools process --advanced --import_path $1/mapillary_copy --user_name trolleway  --verbose --rerun --interpolate_directions  --offset_angle 0 --cutoff_distance 100 --cutoff_time 60 --overwrite_EXIF_direction_tag
mapillary_tools upload --import_path $1/mapillary_copy --skip_subfolders --number_threads 2 --max_attempts 10 --advanced
echo 'ok'
