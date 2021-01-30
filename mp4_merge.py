#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import os
from icecream import ic

def argparser_prepare():

    class PrettyFormatter(argparse.ArgumentDefaultsHelpFormatter,
        argparse.RawDescriptionHelpFormatter):

        max_help_position = 35

    parser = argparse.ArgumentParser(description='merge GoPro 8 h265 video without re-encoding',
            formatter_class=PrettyFormatter)

    parser.add_argument( dest='path')


    return parser

parser = argparser_prepare()
args = parser.parse_args()

assert(os.path.exists(args.path))
if os.path.isfile(args.path):
    path = os.path.dirname(args.path)
else:
    path = args.path
ic(path)
#search case-insensitive for mp4, convert to mpeg transport stream file

mp4s = list()        
for file in os.listdir(path):
    if file.upper().endswith(".MP4"):
        ic(os.path.join(path, file))
        mp4s.append(os.path.join(path, file))
assert len(mp4s) > 0
        
for srcvideo in mp4s:
    target = os.path.splitext(srcvideo)[0]
    cmd = 'ffmpeg -y -i {srcvideo} -c copy  -f mpegts {target}.ts'.format(srcvideo = srcvideo, target = target)
    ic(cmd)
    os.system(cmd)
#find $1 -type f -iname "*.mp4" |  parallel ffmpeg -y -i {} -c copy -bsf:v h264_mp4toannexb -f mpegts {.}.ts

#search mpeg transport stream files, implode list for ffmpeg call
ts_list = list()        
for file in os.listdir(path):
    if file.upper().endswith(".TS"):
        ic(os.path.join(path, file))
        ts_list.append(os.path.join(path, file))
assert len(ts_list) > 0
ts_files = '|'.join(ts_list)

#ts_files=$(find $1 -type f -iname "*.ts"| tr '\n' '|')
target = os.path.join(path,'merge')
cmd = 'ffmpeg -i "concat:{ts_files}" -y -c copy -bsf:a aac_adtstoasc {target}.mp4'.format(ts_files = ts_files, target = target)
ic(cmd)
os.system(cmd)
#merge ts files
#ffmpeg -i "concat:$ts_files" -y -c copy -bsf:a aac_adtstoasc merge.mp4

#delete TS files

for file in ts_list:
    os.unlink(file)