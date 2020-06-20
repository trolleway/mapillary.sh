#!/bin/bash

# $1 - path to SJCAM photos folder
# $2 - date taken in YYYY-MM-DD format

#write DateTime to SJCAM photo, taken from filename and given date

find $1 -name "*.JPG" | parallel --bar bash ./filename2date.sh {} $2

echo "Do a georefrence photos in $1"
