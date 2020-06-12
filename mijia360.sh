#!/bin/bash
#usage() {                                      # Function: Print a help message.
#  echo "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary" 1>&2 
#  echo "Usage: $0 [ --u mapillary username ] [ -s --source folder with georefrenced images ]" 1>&2 
#}

usage() { printf "Upload Xiaomi Mijia 360 georefrenced photos to Mapillary \n Usage: $0 [-u <mapillary username>] [-p <password>] [-a <offset angle>] [-s <source folder>]" 1>&2; exit 1; }

while getopts ":u:p:a:s:" o; do
    case "${o}" in
        u)
            USERNAME=${OPTARG}
            #((s == 45 || s == 90)) || usage
            ;;
        p)
            PASSWORD=${OPTARG}
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

if [ -z "${USERNAME}" ] || [ -z "${PASSWORD}" ] || [ -z "${ANGLE}" ] || [ -z "${PATH}" ] ; then
    usage
fi

#echo "s = ${s}"
#echo "p = ${p}"
#-------------------


