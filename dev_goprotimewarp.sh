DIR="/data/padalsk"

FN="GH018108"


USERNAME="trolleway"
ANGLE=0
INTERVAL=0.1
TIMESTAMP=1609583488

#generate frames with datetime
time exiftool -ee -p gpx.fmt $DIR/$FN.mp4 > $FN.gpx

#simplify gpx for reduce jagged points
gpsbabel -r -i gpx  -f $DIR/$FN.gpx -x simplify,lenght,error=0.001 -o gpx -F $DIR/$FN-simplify.gpx

time mapillary_tools video_process  --video_import_path "$DIR" \
--user_name $USERNAME --advanced --video_duration_ratio 10 --device_make GoPro --device_model "HERO8 Black" \
--video_sample_interval $INTERVAL --geotag_source "gopro_videos" --geotag_source_path "$DIR" \
 --use_gps_start_time --interpolate_directions --offset_angle $ANGLE 

# get ts of frist frame
#---- calc time difference by start track
FRAMEFRIST=$(find $DIR/mapillary_sampled_video_frames -name '*.jpg' | sort | head -1)
FRAMETIME=$(exiftool -s -s -s -d "%Y-%m-%d %H:%M:%S" -DateTimeOriginal $FRAMEFRIST)
FRAMETS=$(date -d "$FRAMETIME" +"%s")

GPXSTART=$(gpxinfo $DIR/$FN.gpx | grep Started |  head -1 )
GPXSTART=${GPXSTART:13:21}  
GPXTS=$(date -d "$GPXSTART" +"%s")  
GPXSTART_EXIFTOOL=$(date -d "$GPXSTART" +"%Y:%m:%d %H:%M:%S")  
echo $GPXTS

deltaTS=$((FRAMETS - GPXTS))
echo $deltaTS

deltaHMS=$(date -d @$deltaTS +"%T")
echo 'delta_begin='$deltaHMS
#---- calc time difference by end track
FRAMELAST=$(find $DIR/mapillary_sampled_video_frames -name '*.jpg' | sort | tail -1)
FRAMETIME=$(exiftool -s -s -s -d "%Y-%m-%d %H:%M:%S" -DateTimeOriginal $FRAMELAST)
FRAMETS=$(date -d "$FRAMETIME" +"%s")

GPXFINISH=$(gpxinfo $DIR/$FN.gpx | grep Ended |  head -1 )
GPXFINISH=${GPXFINISH:11:19}  
GPXFINISH_EXIFTOOL=$(date -d "$GPXFINISH" +"%Y:%m:%d %H:%M:%S")
echo $GPXFINISH
GPXTS=$(date -d "$GPXFINISH" +"%s")  
echo $GPXTS

deltaTS=$((FRAMETS - GPXTS))
echo $deltaTS

deltaHMS=$(date -d @$deltaTS +"%T")
echo 'delta_begin='$deltaHMS

#time exiftool  -overwrite_original "-AllDates-=$deltaHMS"  mapillary_sampled_video_frames/$FN/*.jpg
#geosync with time drift
#'-Geotime<${DateTimeOriginal}-03:00'
time exiftool  -overwrite_original -geotag -verbose $DIR/$FN-simplify.gpx  -geosync="$GPXSTART_EXIFTOOL@$FRAMEFRIST"  -geosync="$GPXFINISH@$FRAMELAST" mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original  -v -geotag $DIR/$FN-simplify.gpx  -geosync="2021:01:16 15:32:04.@$FRAMEFRIST"  -geosync="2021:01:16 15:41:31@$FRAMELAST" mapillary_sampled_video_frames/$FN/*.jpg

time exiftool "-AllDates+=$deltaHMS" -verbose mapillary_sampled_video_frames/$FN/GH018150_000002.jpg
# try use simplified gpx

#time mapillary_tools video_process  --video_import_path "$DIR" \
#--user_name $USERNAME --advanced --video_duration_ratio 10 --device_make GoPro --device_model "HERO8 Black" \
#--video_sample_interval $INTERVAL --geotag_source "gpx" --geotag_source_path "$DIR/$FN-simplify.gpx" \
# --video_start_time $TIMESTAMP --interpolate_directions --offset_angle $ANGLE 
 
 
# generate gpx
#time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
# --geotag_source "gopro_videos" --geotag_source_path "$DIR" --local_time --use_gps_start_time --overwrite_all_EXIF_tags \
# --interpolate_directions --offset_angle $ANGLE 


# get gpx start time 
#pip install gpxpy


#georefrence to gopro track
time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
 --geotag_source "gpx" --geotag_source_path "$DIR/$FN-simplify.gpx" --local_time --use_gps_start_time --overwrite_all_EXIF_tags \
 --interpolate_directions --offset_angle $ANGLE 
 
#copy geodata from exif to imagedescription
time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
 --geotag_source "exif" --overwrite_all_EXIF_tags \
 --interpolate_directions --offset_angle $ANGLE 
 
echo 'ok'

#
