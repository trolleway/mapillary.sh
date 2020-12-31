#!/bin/bash

# $1 - path to folder
# $2 - angle 
# $3 - mapillary username



#If some files has gps tags, sone not has

#drop csv header, calc lines with empty gps tags (looks like ,,)
nogps_count=$(exiftool -q -q  -csv  -gpslatitude -gpslongitude  $1 | tail -n +2 | grep ',,' |   wc -l)

echo nogps_count = $nogps_count
#need spaces around brackets
if [ "$nogps_count" -gt 0 ]; then
	echo 'There are some images withouth GPS positon in input folder. To not mistake folder, Geotag it in JOSM or delete';
	echo $nogps_list;
	exit 1;
fi

#If none fails has gps tags, this columns will not get into CSV. Check CSV header
nogps_count=$(exiftool  -q -q  -csv  -gpslatitude -gpslongitude  $1 | grep 'GPSLongitude' | wc -l)

#need spaces around brackets
if [ "$nogps_count" -eq 0 ]; then
	echo 'There are all images withouth GPS positon in input folder. Geotag it in JOSM';

	exit 1;
fi


mapillary_tools video_process  --video_import_path "$1" \
--user_name $3 --advanced --geotag_source "gopro_videos" --geotag_source_path "$1" \
--interpolate_directions --video_sample_interval 0.5 --interpolate_directions --offset_angle $2 --overwrite_EXIF_gps_tag  2> /dev/null 

#---------------
#mapillary_tools process --advanced --import_path "$1" --user_name $3 --cutoff_distance 100 --cutoff_time 60 \
#--interpolate_directions --offset_angle $2 --rerun --overwrite_EXIF_direction_tag 2> /dev/null  
#
#mapillary_tools upload --import_path "$1" --skip_subfolders --number_threads 4 --max_attempts 50 --advanced
echo "End" 
  