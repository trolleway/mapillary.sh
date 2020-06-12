#!/bin/bash
for i in "$@"
do
case $i in
    -u=*|--username=*)
    USERNAME="${i#*=}"

    ;;
    -a=*|--angle=*)
    ANGLE="${i#*=}"
    ;;
    -s=*|--source=*)
    SOURCE="${i#*=}"
    ;;
    *)
            # unknown option
    ;;
esac
done
echo USERNAME = ${USERNAME}
echo ANGLE = ${ANGLE}
echo SOURCE = ${SOURCE}
