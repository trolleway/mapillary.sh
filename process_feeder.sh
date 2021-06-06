#!/bin/bash


path="/data/mapillary.sh/feeder"

mapillary_tools process_and_upload --advanced --import_path "$path/0" --user_name trolleway  \
--interpolate_directions --offset_angle 0  --overwrite_EXIF_direction_tag 
mapillary_tools process_and_upload --advanced --import_path "$path/90" --user_name trolleway  \
--interpolate_directions --offset_angle 90  --overwrite_EXIF_direction_tag 
mapillary_tools process_and_upload --advanced --import_path "$path/180" --user_name trolleway  \
--interpolate_directions --offset_angle 180  --overwrite_EXIF_direction_tag
mapillary_tools process_and_upload --advanced --import_path "$path/270" --user_name trolleway  \
--interpolate_directions --offset_angle 270  --overwrite_EXIF_direction_tag 

mapillary_tools process_and_upload --advanced --import_path "$path/keep_direction" --user_name trolleway   \
--interpolate_directions  --overwrite_EXIF_direction_tag 


echo "End"  
  
