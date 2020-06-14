#!/usr/bin/python
# -*- coding: utf8 -*-

#from datetime import datetime, timedelta
import datetime
import time
import os
import shutil

import argparse

def get_args():
    import argparse
    p = argparse.ArgumentParser(description='Process folder with videofiles from Advocam dashcam and gpx file, upload frames to Mapillary. Datetime of videofiles determined from filenames')
    p.add_argument('--testmode', dest='testmode', action='store_true', help='Test commands, not perform actions')
    p.add_argument('--skip_upload', dest='skip_upload', action='store_true', help='perform all actions except upload')
    p.add_argument('--date', help='date in YYYY-MM-DD',required=True)
    p.add_argument('--path', help='path to mp4 folder',required=True)
    p.add_argument('--gpx', help='Location of GPX file to get locations from.')
    p.add_argument('--offset_time', help='offset time',required=True)
     
    #p.add_argument('time_offset',
    #    help='Time offset between GPX and photos. If your camera is ahead by one minute, time_offset is 60.',
    #    default=0, type=float, nargs='?') # nargs='?' is how you make the last positional argument optional.
    return p.parse_args()
    
    
args = get_args()
testmode = args.testmode
skip_upload=args.skip_upload

print(testmode)
print(skip_upload)

mapillary_tools = 'c:\gis\pano_heading\mapillary_tools.exe'
mapillary_tools = 'mapillary_tools'
CROPPED_FOLDER = 'cropped'

pathsrc = 'c:/mav/cardv/'
pathsrc = args.path



files = []
for dirpath, dnames, fnames in os.walk(pathsrc):
    for f in fnames:
        if f.upper().endswith(".MP4"):
             files.append(os.path.join(dirpath, f))

for filepath in files:

 #create dir if not exists
    cropped_folder_path = os.path.join(os.path.dirname(filepath),CROPPED_FOLDER)
    shutil.rmtree(cropped_folder_path,ignore_errors=True)
    if not os.path.exists(cropped_folder_path):
        os.makedirs(cropped_folder_path)
        
    cropped_filepath = os.path.join(os.path.dirname(filepath),CROPPED_FOLDER,os.path.basename(filepath))
        
    #convert video: redude fps to 8 for faster processing in mapillary_tools
    cmd = '''ffmpeg -y -i "'''+os.path.normpath(filepath)+'''"  -loglevel panic -r 8  -c:a copy "'''+os.path.normpath(cropped_filepath)+'''"'''
    print(cmd)
    # crop image -vf crop=iw:ih-140:0:0
    
    if testmode is None:
        pass
    os.system(cmd)    
    
    path = os.path.join(pathsrc,CROPPED_FOLDER)
               
    filepath = cropped_filepath
    filename = os.path.basename(filepath)
    filedate_from_name = args.date
    filetime_from_name = filename[0:6]  

    #get video begin datetime from video filename
    timestamp = time.mktime(datetime.datetime.strptime(filedate_from_name+'_'+filetime_from_name, "%Y%m%d_%H%M%S").timetuple())

    unix_timestamp_ms = int(timestamp)*1000
    unix_timestamp_timezone = unix_timestamp_ms+(0*60*60*1000)
    print('timezone calculation '+str(unix_timestamp_timezone))

    # sample video
    cmd = '''{mapillary_tools} sample_video --video_import_path "'''+os.path.normpath(filepath)+'''" --video_sample_interval 0.25 --video_start_time {unix_timestamp_timezone} --advanced'''
    cmd = cmd.format(mapillary_tools=mapillary_tools,unix_timestamp_timezone=unix_timestamp_timezone)
    print(cmd)
    if testmode==False:
        os.system(cmd)

    sampled_video_frames_path = os.path.join(os.path.dirname(filepath),'mapillary_sampled_video_frames')
    
    # geotag frames using gpx file
    gpx=args.gpx
    cmd = ''' {mapillary_tools} process --advanced --import_path "'''+os.path.normpath(os.path.join(sampled_video_frames_path, os.path.splitext(filename)[0]))+'''" --user_name "trolleway" --geotag_source "gpx" --geotag_source_path "'''+gpx+'''" --offset_time "'''+args.offset_time+'''" --overwrite_all_EXIF_tags '''
    cmd = cmd.format(mapillary_tools=mapillary_tools)
    print(cmd)
    if testmode==False:
        os.system(cmd)
    
    # upload to mapillary
    cmd = ''' {mapillary_tools} upload --import_path "'''+os.path.normpath(os.path.join(sampled_video_frames_path, os.path.splitext(filename)[0]))+'''" --skip_subfolders --number_threads 5 --max_attempts 10 --advanced'''
    cmd = cmd.format(mapillary_tools=mapillary_tools)
    print(cmd)
    if (testmode==False) and (skip_upload==False):
        os.system(cmd)   
        
        

    #print datetime_object
    #print totimestamp(datetime_object)


    '''
    ffmpeg -y -i sample.mp4 -f lavfi -i color=c=black:s=30x40 -filter_complex "[1:v]scale=w=iw:h=ih[scaled]; [0:v][scaled]overlay=x=0.20*main_w:y=0.10*main_h:eof_action=‌​endall[out]; [0:a]anull[aud]" -map "[out]" -map "[aud]" -strict -2 outputfile.mp4
    '''
    
    '''
    crop video
    ffmpeg -i g:\VIDEO\2019_04_reg\stage2\CarDV_20190427_172205A.MP4 -vf crop=iw:ih-140:0:0 -c:a copy g:\VIDEO\2019_04_reg\stage2\cropped\CarDV_20190427_172205A.MP4
    '''
