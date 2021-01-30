#!/bin/sh

mapillary_auth() {
mapillary_tools --advanced authenticate
}

xiaomi360_geotag() {
dialog --title "Choose any file in folder" --fselect ~ 30 60
FILE=$(dialog --stdout --title "Choose any file in folder with JPG and gpx" --fselect $HOME/ 14 48)
echo "${FILE} file chosen."


if   [ -d "${FILE}" ]
then echo 'dir';
elif [ -f "${FILE}" ]
then FILE=$(dirname $FILE);
else echo "${FILE} is not valid";
     
fi



bash mijia360_geosync.sh ${FILE}
read -n 1 -s -r -p "Press any key to continue"
}

#---

process_and_upload() {
dialog --title "Choose any file in folder" --fselect ~ 30 60
FILE=$(dialog --stdout --title "Choose folder with JPG" --fselect $HOME/ 14 48)
echo "${FILE} file chosen."



if   [ -d "${FILE}" ]
then echo 'dir';
elif [ -f "${FILE}" ]
then FILE=$(dirname $FILE);
else echo "${FILE} is not valid";
     
fi

# ----- angle

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --title "My input box" --clear \
        --inputbox "Enter offset_angle\n
0..360:" 16 51 2> $tempfile

retval=$?

case $retval in
  0)
    echo "Input string is `cat $tempfile`";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "ESC pressed."
	  return
    fi
    ;;
esac

ANGLE=$(cat $tempfile)

# ----- username

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --title "My input box" --clear \
        --inputbox "Enter mapillary username\n
You sholuld do mapillary_auth before:" 16 51 2> $tempfile

retval=$?

case $retval in
  0)
    echo "Input string is `cat $tempfile`";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "ESC pressed."
	  return
    fi
    ;;
esac

USERNAME=$(cat $tempfile)

bash process_and_upload.sh $FILE $ANGLE $USERNAME
read -n 1 -s -r -p "Press any key to continue"
}



xiaomi360_logo() {
dialog --title "Choose any file in folder" --fselect ~ 30 60
FILE=$(dialog --stdout --title "Choose any file in folder with JPG " --fselect $HOME/ 14 48)
echo "${FILE} file chosen."


if   [ -d "${FILE}" ]
then echo 'dir';
elif [ -f "${FILE}" ]
then FILE=$(dirname $FILE);
else echo "${FILE} is not valid";
     
fi


bash logo360/overlay_logo.sh ${FILE}
read -n 1 -s -r -p "Press any key to continue"
}


gopro_video() {
dialog --title "Choose any file in folder" --fselect ~ 30 60
FILE=$(dialog --stdout --title "Choose any file in folder with GoPro videos " --fselect $HOME/ 14 48)
echo "${FILE} file chosen."


if   [ -d "${FILE}" ]
then echo 'dir';
elif [ -f "${FILE}" ]
then FILE=$(dirname $FILE);
else echo "${FILE} is not valid";
     
fi

# ----- angle

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --title "My input box" --clear \
        --inputbox "Enter offset_angle\n
0..360:" 16 51 2> $tempfile

retval=$?

case $retval in
  0)
    echo "Input string is `cat $tempfile`";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "ESC pressed."
	  return
    fi
    ;;
esac

ANGLE=$(cat $tempfile)

# ----- username

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --title "My input box" --clear \
        --inputbox "Enter mapillary username\n
You sholuld do mapillary_auth before:" 16 51 2> $tempfile

retval=$?

case $retval in
  0)
    echo "Input string is `cat $tempfile`";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "ESC pressed."
	  return
    fi
    ;;
esac

USERNAME=$(cat $tempfile)

bash gopro_video.sh $FILE $ANGLE $USERNAME
read -n 1 -s -r -p "Press any key to continue"
}

#---
mp4_merge() {
dialog --title "Choose any file in folder" --fselect ~ 30 60
FILE=$(dialog --stdout --title "Choose any file in folder with MP4" --fselect $HOME/ 14 48)
echo "${FILE} file chosen."


if   [ -d "${FILE}" ]
then echo 'dir';
elif [ -f "${FILE}" ]
then FILE=$(dirname $FILE);
else echo "${FILE} is not valid";
     
fi

bash mp4_merge.sh ${FILE}
read -n 1 -s -r -p "Press any key to continue"
}



while true
do
DIALOG=${DIALOG=dialog}
tempfile=`mktemp 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --clear --title "Select operation" \
        --menu "Select operation:" 20 81 8 \
        "mapillary_auth"  "Mapillary_tools auth" \
        "xiaomi360_geotag" "Geotag folder Xiaomi360 images with gpx track" \
        "process_and_upload" "process_and_upload images to Mapillary, set angle and username" \
        "xiaomi360_logo" "Overlay logo on Xiaomi360 images" \
        "gopro_video" "GoPro video process_and_upload" \
        "mp4_merge" "GoPro video merge" \
        "exit"  "Exit" 2> $tempfile

retval=$?

choice=`cat $tempfile`



case $retval in
  0)

    case $choice in
        mapillary_auth) mapillary_auth;;
        xiaomi360_geotag) xiaomi360_geotag;;
        process_and_upload) process_and_upload;;
        xiaomi360_logo) xiaomi360_logo;;
        gopro_video) gopro_video;;
        mp4_merge) mp4_merge;;
        exit) exit;;
    esac;;
  1)
    echo "Отказ от ввода."
    exit;;
  255)
    echo "Нажата клавиша ESC."
    exit;;
esac
done
