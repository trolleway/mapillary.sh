#!/bin/sh

filename=$(basename -s .JPG "$1")

# $1  path to JPG file. It name should begin with HHMMSS sequence
# $2 date in YYYY-MM-DD

#photo_date=$2

hour=${filename:0:2}
min=${filename:2:2}
sec=${filename:4:2}

text="$2 $hour:$min:$sec"
exiftool -quiet -overwrite_original -timeZoneOffset=-3 -DateTime=" $text" -CreateDate=" $text" -FileModifyDate=" $text" -DateTimeOriginal=" $text" $1