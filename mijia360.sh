#!/bin/bash
#usage() {                                      # Function: Print a help message.
#  echo "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary" 1>&2 
#  echo "Usage: $0 [ --u mapillary username ] [ -s --source folder with georefrenced images ]" 1>&2 
#}

usage() { echo "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }

while getopts ":s:p:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ] || [ -z "${p}" ]; then
    usage
fi

echo "s = ${s}"
echo "p = ${p}"
#-------------------

#echo USERNAME = ${USERNAME}
#echo ANGLE = ${ANGLE}
#echo SOURCE = ${SOURCE}
