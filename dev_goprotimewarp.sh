DIR="/data/padalsk"

FN="GH018150"


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

FRAME1=$(find $DIR/mapillary_sampled_video_frames -name '*.jpg' | sort | head -1)
FRAMETIME=$(exiftool -s -s -s -d "%Y-%m-%d %H:%M:%S" -DateTimeOriginal $FRAME1)
echo $FRAMETIME
FRAMETS=$(date -d "$FRAMETIME" +"%s")
echo $FRAMETS

GPXTS=$(gpxinfo $DIR/$FN.gpx | grep Started |  head -1 )
GPXTS=${GPXTS:13:21}  
GPXTS=$(date -d "$GPXTS" +"%s")  

echo $GPXTS
deltaTS=$((FRAMETS - GPXTS))
echo $deltaTS

deltaHMS=$(date -d @$deltaTS +"%T")

time exiftool  -overwrite_original "-AllDates-=$deltaHMS"  mapillary_sampled_video_frames/$FN/*.jpg

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
STARTTIME=$(gpxinfo $DIR/$FN.gpx | grep Started |  head -1 )
STARTTIME=${STARTTIME:13:21} 
echo $STARTTIME
TS=$(date -d "$STARTTIME" +"%s")
echo $TS


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
