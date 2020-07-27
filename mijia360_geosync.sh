#!/bin/bash

# geosync photos. Mijia360 do not store timezone, so manual tiezone shift performing here
#$1 - path to Mijia360 photos taken in UTM+3 zone

gpx=$(find  $1/*.gpx)
if [ -z "$gpx" ]
then
      echo "not foud .gpx file at $1"
      exit 1
fi
      
exiftool -overwrite_original -P -geotag=$gpx '-Geotime<${DateTimeOriginal}+03:00' $1
