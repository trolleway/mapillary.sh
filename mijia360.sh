#!/bin/bash
usage() {                                      # Function: Print a help message.
  echo "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary" 1>&2 
  echo "Usage: $0 [ --u mapillary username ] [ -s --source folder with georefrenced images ]" 1>&2 
}

(( $# )) || usage()
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
