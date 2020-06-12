#!/bin/bash


# RUN apt-cache policy tzdata
# RUN apt-get install except

usage() { printf "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary \n Usage: $0 [-u <mapillary username>] [-p <password>] [-a <offset angle>] [-s <source folder>]" 1>&2; exit 1; }

while getopts ":u:a:s:" o; do
    case "${o}" in
        u)
            USERNAME=${OPTARG}
            #((s == 45 || s == 90)) || usage
            ;;
        a)
            ANGLE=${OPTARG}
            ;;
        s)
            PATH=${OPTARG}
            ;;    
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo USERNAME = ${USERNAME}
echo PASSWORD = ${PASSWORD}
echo ANGLE = ${ANGLE}
echo PATH = ${PATH}

if [ -z "${USERNAME}" ]  || [ -z "${ANGLE}" ] || [ -z "${PATH}" ] ; then
    usage
fi


USERNAME="trolleway"
ANGLE="180"

mapillary_tools process --advanced --import_path "$PATH" --user_name $USERNAME --cutoff_distance 100 --cutoff_time 60 --interpolate_directions --offset_angle $ANGLE --rerun --overwrite_EXIF_direction_tag 2> /dev/null


i=1
sp="/-\|"
echo -n ' '
for file in "$PWD"
do
  exiftool -overwrite_original -quiet -ProjectionType="equirectangular" -UsePanoramaViewer="True" -"PoseHeadingDegrees<$exif:GPSImgDirection" -"CroppedAreaImageWidthPixels<$ImageWidth" -"CroppedAreaImageHeightPixels<$ImageHeight" -"FullPanoWidthPixels<$ImageWidth" -"FullPanoHeightPixels<$ImageHeight" -CroppedAreaLeftPixels="0" -CroppedAreaTopPixels="0" "$file" mapillary_tools process --advanced --import_path "$PWD" --user_name $USERNAME --cutoff_distance 100 --cutoff_time 60 --interpolate_directions --offset_angle $ANGLE --rerun --overwrite_EXIF_direction_tag  2> /dev/null
  printf "\b${sp:i++%${#sp}:1}"
done
mapillary_tools upload --import_path "$PWD" --skip_subfolders --number_threads 5 --max_attempts 10 --advanced

