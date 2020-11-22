#time1=20200612160735
#time1=$2

# $1 - path to mp4 videofile. It should start from HHMMSS sequence, describing start of video record
# $2 - date in YYYYMMDD (no dash)
# $3 - seconds (timecode)

filename=$(basename -s .MP4 "$1")

date1=$2

# convert YYYY-MM-DD to YYYYMMDD
year=${date1:0:4}
month=${date1:5:2}
day=${date1:7:2}
date1=$year$month$day

hour=${filename:0:2}
min=${filename:2:2}
sec=${filename:4:2}

time1=$date1$hour$min$sec

video_dir=$(dirname "$1") 

unixtime1=$(date --date "$(echo "$time1" | sed -nr 's/(....)(..)(..)(..)(..)(..)/\1-\2-\3 \4:\5:\6/p')" +%s)
delta=$((unixtime1 + $3))
# with date  timestamp=$(date --date  @$delta +"%Y%m%d%k%M%S");
timestamp=$(date --date  @$delta +"%k%M%S");

ffmpeg -y -loglevel panic -accurate_seek -ss $3.0 -i $1   -frames:v 1 $video_dir/$timestamp.JPG