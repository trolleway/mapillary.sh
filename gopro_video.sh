#!/bin/bash

# $1 - path to folder
# $2 - angle 
# $3 - mapillary username


mapillary_tools video_process  --video_import_path "$1" \
--user_name $3 --advanced --geotag_source "gopro_videos" --geotag_source_path "$1" \
--interpolate_directions --video_sample_interval 0.5 --interpolate_directions --offset_angle $2 --overwrite_EXIF_gps_tag  2> /dev/null 

#---------------
#mapillary_tools process --advanced --import_path "$1" --user_name $3 --cutoff_distance 100 --cutoff_time 60 \
#--interpolate_directions --offset_angle $2 --rerun --overwrite_EXIF_direction_tag 2> /dev/null  
#
#mapillary_tools upload --import_path "$1" --skip_subfolders --number_threads 4 --max_attempts 50 --advanced
echo "End" 
  