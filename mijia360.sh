#!/bin/bash
usage="$(basename "$0") Upload Xiaomi Mijia 360 georefrenced photos to Mapillary --u mapillary username -a --angle offset angle -s --source folder with georefrenced images

(( $# )) || echo "$usage" >&2
for i in "$@"
do
case $i in
    -u=*|--username=*)
    USERNAME="${i#*=}"

    ;;
    -a=*|--angle=*)
    ANGLE="${i#*=}"
    ;;
    -s=*|--source=*)
    SOURCE="${i#*=}"
    ;;
    -h=*|--help=*)
    echo $usage;
    ;;
    *)
            # unknown option
    ;;
esac
done
echo USERNAME = ${USERNAME}
echo ANGLE = ${ANGLE}
echo SOURCE = ${SOURCE}
