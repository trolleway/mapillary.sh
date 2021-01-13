DIR="/data/20210106_PERESLAVL/work"
#WRK="/data/20210106_PERESLAVL/work"
FN="GH010226"


USERNAME="trolleway"
ANGLE=270
INTERVAL=0.1

#generate frames with datetime

time mapillary_tools video_process  --video_import_path "$DIR" \
--user_name $USERNAME --advanced --video_duration_ratio 10 --device_make GoPro --device_model "HERO8 Black" \
--video_sample_interval $INTERVAL --geotag_source "gopro_videos" --geotag_source_path "$DIR" \
 --use_gps_start_time --interpolate_directions --offset_angle $ANGLE 


# generate gpx
#time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
# --geotag_source "gopro_videos" --geotag_source_path "$DIR" --local_time --use_gps_start_time --overwrite_all_EXIF_tags \
# --interpolate_directions --offset_angle $ANGLE 

#simplify gpx for reduce jagged points
gpsbabel -r -i gpx  -f $DIR/$FN.gpx -x simplify,lenght,error=0.001 -o gpx -F $DIR/$FN-simplify.gpx

#georefrence
time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
 --geotag_source "gpx" --geotag_source_path "$DIR/$FN-simplify.gpx" --local_time --use_gps_start_time --overwrite_all_EXIF_tags \
 --interpolate_directions --offset_angle $ANGLE 
 
echo 'ok'

#
