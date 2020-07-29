#!/bin/bash

# geosync photos. Mijia360 do not store timezone, so manual tiezone shift performing here
#$1 - path to Mijia360 photos taken in UTM+3 zone

gpx=$(find  $1/*.gpx)
if [ -z "$gpx" ]
then
      echo "not foud .gpx file at $1"
      exit 1
fi

#search .JPG case in-sensitive
#run in parallel with progressbar

ls $1/*.[jJ][pP][gG]* | parallel --bar --jobs 2 exiftool -overwrite_original -P -geotag=$gpx "-Geotime<${DateTimeOriginal}+03:00" {}
