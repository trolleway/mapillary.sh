FN="GH018642"



DIR="/data/20210106_PERESLAVL"

USERNAME="trolleway"
ANGLE=0
INTERVAL=0.1 #0.1
RATIO=15 #10

#generate frames with datetime
if [[ ! -f $DIR/$FN.gpx ]]
then
    time exiftool -ee -p gpx.fmt $DIR/$FN.mp4 > $DIR/$FN.gpx
fi


time gpsbabel -v -i gpx -f $DIR/$FN.gpx -o subrip,format="GPS time %t" -F $DIR/$FN.srt
time ffmpeg -y -i $DIR/$FN.mp4 -i "$DIR/Famous - Highway (1983).mp3" -vcodec libx264 -vf 'scale=1280:trunc(ow/a/2)*2' -acodec aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k -ar 44100 -strict experimental  $DIR/$FN-tw.mp4
time ffmpeg -y -i $DIR/$FN.mp4 -vcodec libx264 -vf 'scale=640:trunc(ow/a/2)*2' -preset faster -acodec aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k -ar 44100 -strict experimental  $DIR/$FN-tw.mp4

#simplify gpx for reduce jagged points
gpsbabel -r -i gpx  -f $DIR/$FN.gpx -x simplify,lenght,error=0.001 -o gpx -F $DIR/$FN-simplify.gpx


time mapillary_tools video_process  --video_import_path "$DIR" \
--user_name $USERNAME --advanced --video_duration_ratio $RATIO --device_make GoPro --device_model "HERO8 Black" \
--video_sample_interval $INTERVAL --geotag_source "gopro_videos" --geotag_source_path "$DIR" \
 --use_gps_start_time --interpolate_directions --offset_angle $ANGLE 

# georefrence in JOSM here to gpx track from external device. GoPro timewarp tracks has too low time presision

time exiftool -progress -overwrite_original -r -ImageDescription= *.jpg

time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make "GoPro" --device_model "HERO8 Black"\
 --interpolate_directions --offset_angle $ANGLE

time mapillary_tools upload --import_path "$DIR/mapillary_sampled_video_frames"

# --geotag_source "exif" --overwrite_all_EXIF_tags \



time exiftool -progress -overwrite_original -r -ImageDescription= *.jpg

time mapillary_tools process --advanced --rerun --import_path "${PWD}" --user_name $USERNAME  --device_make "GoPro" --device_model "HERO8 Black"\
 --interpolate_directions --offset_angle $ANGLE


time mapillary_tools process_and_upload --advanced --rerun --import_path "${PWD}" --user_name $USERNAME  --device_make "GoPro" --device_model "HERO8 Black"\
 --interpolate_directions --offset_angle $ANGLE





#--------deltaHMS


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

# get ts of frist frame
#---- calc time difference by start track
FRAMEFRIST=$(find $DIR/mapillary_sampled_video_frames -name '*.jpg' | sort | head -1)
FRAMETIME=$(exiftool -s -s -s -d "%Y-%m-%d %H:%M:%S" -DateTimeOriginal $FRAMEFRIST)
FRAMETS=$(date -d "$FRAMETIME" +"%s")

GPXSTART=$(gpxinfo $DIR/$FN.gpx | grep Started |  head -1 )
GPXSTART=${GPXSTART:13:21} 
GPXSTART_TS=$(date -d "$GPXSTART" +"%s")
GPXSTART_TS=$((GPXSTART_TS + 5))

GPXSTART_EXIFTOOL=$(date -d "@$GPXSTART_TS" +"%Y:%m:%d %H:%M:%S")  
echo $GPXSTART_EXIFTOOL

#---- calc time difference by end track
FRAMELAST=$(find $DIR/mapillary_sampled_video_frames -name '*.jpg' | sort | tail -1)
FRAMETIME=$(exiftool -s -s -s -d "%Y-%m-%d %H:%M:%S" -DateTimeOriginal $FRAMELAST)
FRAMETS=$(date -d "$FRAMETIME" +"%s")

GPXFINISH=$(gpxinfo $DIR/$FN.gpx | grep Ended |  head -1 )
GPXFINISH=${GPXFINISH:11:19}  
GPXFINISH_TS=$(date -d "$GPXFINISH" +"%s")
GPXFINISH_TS=$((GPXFINISH_TS + 5))

GPXFINISH_EXIFTOOL=$(date -d "@$GPXFINISH_TS" +"%Y:%m:%d %H:%M:%S")

echo $GPXSTART_EXIFTOOL
echo $GPXFINISH_EXIFTOOL


#geosync with time drift
#'-Geotime<${DateTimeOriginal}-03:00'

exiftool  -overwrite_original -progress "-AllDates-=$deltaHMS"  $DIR/mapillary_sampled_video_frames/$FN/*.jpg

time exiftool  -overwrite_original -progress -geotag= $DIR/mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original -progress -geotag  $DIR/$FN-simplify.gpx -geosync="$GPXSTART_EXIFTOOL@$FRAMEFRIST"  -geosync="$GPXFINISH_EXIFTOOL@$FRAMELAST" $DIR/mapillary_sampled_video_frames/$FN/*.jpg


#gps + 5s
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx -geosync="2021:01:06 18:55:38@2021:01:06 18:56:07"  -geosync="2021:01:06 19:04:17@2021:01:06 19:04:12" $DIR/mapillary_sampled_video_frames/$FN/*.jpg


#gps@img
FN=GH020238
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:06 11:50:10@2021:01:06 14:45:15" \
-geosync="2021:01:06 12:06:50@2021:01:06 15:01:50" \
-geosync="2021:01:06 12:18:39@2021:01:06 15:12:38" \
-geosync="2021:01:06 12:47:00@2021:01:06 15:39:08" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg

#gps@img
FN=GH010244
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:06 10:18:51@2021:01:06 11:53:46" \
-geosync="2021:01:06 10:30:20@2021:01:06 12:04:22" \
-geosync="2021:01:06 10:40:53@2021:01:06 12:14:14" \
-geosync="2021:01:06 10:45:11@2021:01:06 12:17:58" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg


#etalon time exiftool  -overwrite_original  -v -geotag $DIR/$FN-simplify.gpx  -geosync="2021:01:16 15:32:04.@$FRAMEFRIST"  -geosync="2021:01:16 15:41:31@$FRAMELAST" mapillary_sampled_video_frames/$FN/*.jpg

#move date time exiftool "-AllDates+=$deltaHMS" -verbose mapillary_sampled_video_frames/$FN/GH018150_000002.jpg
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
#time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
# --geotag_source "gpx" --geotag_source_path "$DIR/$FN-simplify.gpx" --local_time --use_gps_start_time --overwrite_all_EXIF_tags \
# --interpolate_directions --offset_angle $ANGLE 
 
#copy geodata from exif to imagedescription
#time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make GoPro --device_model "HERO8 Black"\
# --geotag_source "exif" --overwrite_all_EXIF_tags \
# --interpolate_directions --offset_angle $ANGLE 
 

time mapillary_tools upload  --import_path "${PWD}" 


 
 
echo 'ok'

#
