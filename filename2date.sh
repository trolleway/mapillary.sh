#!/bin/sh

filename=$(basename -s .JPG "$1")
#photo_date=$2

hour=${filename:0:2}
min=${filename:2:2}
sec=${filename:4:2}

text="$2 $hour:$min:$sec"
exiftool -quiet -overwrite_original -timeZoneOffset=-3 -DateTime=" $text" -CreateDate=" $text" -FileModifyDate=" $text" -DateTimeOriginal=" $text" $1