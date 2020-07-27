#!/bin/bash

# geosync photos. Mijia360 do not store timezone, so manual tiezone shift performing here
#$1 - path to Mijia360 photos taken in UTM+3 zone


exiftool -overwrite_original -P -geotag=$gpx '-Geotime<${DateTimeOriginal}+03:00' $1
