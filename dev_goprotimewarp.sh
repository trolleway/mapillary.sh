
DIR="/data/20210109"

USERNAME="trolleway"
ANGLE=0
INTERVAL=0.1 #0.1
RATIO=15 #10

find $DIR -type f -iname "*.mp4" | parallel  exiftool -Rate  -q -q  -csv   {} 

time mapillary_tools video_process  --video_import_path "$DIR" \
--user_name $USERNAME --advanced --video_duration_ratio $RATIO --device_make GoPro --device_model "HERO8 Black" \
--video_sample_interval $INTERVAL --geotag_source "gopro_videos" --geotag_source_path "$DIR" \
 --use_gps_start_time --interpolate_directions --offset_angle $ANGLE 
 
 
gpsbabel -r -i gpx  -f $DIR/osmand.gpx -x simplify,lenght,error=0.001 -o gpx -F $DIR/osmand-simplify.gpx






FN=GH011004
#simplify gpx for reduce jagged points
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
rm -r $DIR/mapillary_sampled_video_frames/$FN/.mapillary
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand-simplify.gpx \
-geosync="2021:01:09 10:55:46@13:50:00" \
-geosync="2021:01:09 11:04:16@13:58:02" \
-geosync="2021:01:09 11:18:23@14:09:47" \
-geosync="2021:01:09 11:20:22@14:11:33" \
-geosync="2021:01:09 11:27:32@14:17:54" \
-geosync="2021:01:09 11:36:08@14:25:47" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg



FN=GH011005
#simplify gpx for reduce jagged points
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
rm -r $DIR/mapillary_sampled_video_frames/$FN/.mapillary
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand-simplify.gpx \
-geosync="2021:01:09 11:49:25@14:44:05" \
-geosync="2021:01:09 11:50:59@14:45:49" \
-geosync="2021:01:09 12:35:06@15:22:58" \
-geosync="2021:01:09 12:46:35@15:33:56" \
-geosync="2021:01:09 13:00:30@15:46:29" \
-geosync="2021:01:09 13:15:14@15:59:01" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg



FN=GH011005_2
#simplify gpx for reduce jagged points
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
rm -r $DIR/mapillary_sampled_video_frames/$FN/.mapillary
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand-simplify.gpx \
-geosync="2021:01:09 13:18:13@14:46:27" \
-geosync="2021:01:09 13:30:05@14:57:04" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg


FN=GH011006
#simplify gpx for reduce jagged points
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
rm -r $DIR/mapillary_sampled_video_frames/$FN/.mapillary
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand-simplify.gpx \
-geosync="2021:01:09 13:39:34@16:34:43" \
-geosync="2021:01:09 13:46:04@16:40:23" \
-geosync="2021:01:09 14:12:06@17:03:25" \
-geosync="2021:01:09 14:18:13@17:07:53" \
-geosync="2021:01:09 14:56:06@17:41:28" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg


FN=GH011009
#simplify gpx for reduce jagged points
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
rm -r $DIR/mapillary_sampled_video_frames/$FN/.mapillary
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand-simplify.gpx \
-geosync="2021:01:09 15:09:33@18:08:12" \
-geosync="2021:01:09 15:20:34@18:17:54" \
-geosync="2021:01:09 15:22:45@18:20:13" \
-geosync="2021:01:09 15:34:41@18:30:30" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg




time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames" --user_name $USERNAME  --device_make "GoPro" --device_model "HERO8 Black"\
 --interpolate_directions --offset_angle $ANGLE

time mapillary_tools upload --import_path "$DIR/mapillary_sampled_video_frames"

exit 0


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

#---- start here
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription= -r $DIR/mapillary_sampled_video_frames

# georefrence in JOSM here to gpx track from external device. GoPro timewarp tracks has too low time presision

FN=GH011013
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg

time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:10 10:38:44@13:36:59" \
-geosync="2021:01:10 10:42:48@13:40:35" \
-geosync="2021:01:10 10:55:21@13:51:03" \
-geosync="2021:01:10 11:00:08@13:55:05" \
-geosync="2021:01:10 11:09:44@14:03:24" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg





FN=GH011014
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:10 11:22:53@14:16:34" \
-geosync="2021:01:10 11:35:39@14:27:37" \
-geosync="2021:01:10 11:40:04@14:31:51" \
-geosync="2021:01:10 11:43:16@14:34:24" \
-geosync="2021:01:10 12:33:36@15:20:43" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg



FN=GH011015
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:10 12:50:46@15:48:49" \
-geosync="2021:01:10 12:57:32@15:54:55" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg



FN=GH011016
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:10 13:13:40@16:12:22" \
-geosync="2021:01:10 13:16:45@16:14:56" \
-geosync="2021:01:10 13:21:20@16:19:11" \
-geosync="2021:01:10 13:23:23@16:20:44" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg

time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:10 13:13:40@GH011016_000197.jpg" \
-geosync="2021:01:10 13:23:23@GH011016_000531.jpg" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg


#-----



time exiftool -progress -overwrite_original -r -ImageDescription= *.jpg

time mapillary_tools process --advanced --rerun --import_path "$DIR/mapillary_sampled_video_frames/$FN" --user_name $USERNAME  --device_make "GoPro" --device_model "HERO8 Black"\
 --interpolate_directions --offset_angle $ANGLE

time mapillary_tools upload --import_path "$DIR/mapillary_sampled_video_frames/$FN"

# --geotag_source "exif" --overwrite_all_EXIF_tags \

#----------------

#manual georefrence gopro timewarp by 4 points

FN=GH010842
exiftool  -overwrite_original -progress "-gps*=" -ImageDescription=  $DIR/mapillary_sampled_video_frames/$FN/*.jpg
time exiftool  -overwrite_original -progress -geotag  $DIR/osmand.gpx \
-geosync="2021:01:08 13:13:07@$DIR/mapillary_sampled_video_frames/$FN/$FN_000170.jpg" \
-geosync="2021:01:08 13:13:40@$DIR/mapillary_sampled_video_frames/$FN/$FN_000198.jpg" \
-geosync="2021:01:08 13:16:46@$DIR/mapillary_sampled_video_frames/$FN/$FN_000298.jpg" \
-geosync="2021:01:08 13:20:46@$DIR/mapillary_sampled_video_frames/$FN/$FN_000442.jpg" \
-geosync="2021:01:08 13:24:30@$DIR/mapillary_sampled_video_frames/$FN/$FN_000565.jpg" \
$DIR/mapillary_sampled_video_frames/$FN/*.jpg




time mapillary_tools video_process  --video_import_path "$DIR" \
--user_name $USERNAME --advanced --video_duration_ratio $RATIO --device_make GoPro --device_model "HERO8 Black" \
--video_sample_interval $INTERVAL --geotag_source "gopro_videos" --geotag_source_path "$DIR" \
 --use_gps_start_time --interpolate_directions --offset_angle $ANGLE 



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
