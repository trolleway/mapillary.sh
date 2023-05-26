#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import os, shutil
from tqdm import trange, tqdm
import time

def browser_upload(filename):

    assert os.path.isfile(filename)
    from selenium import webdriver
    from selenium.webdriver.common.keys import Keys
    from selenium.webdriver.common.by import By
    from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
    from selenium.webdriver.remote.file_detector import LocalFileDetector
    from selenium.webdriver.support import expected_conditions as EC
    from selenium.webdriver.support.ui import WebDriverWait
    
    def set_chrome_options() -> None:
        from selenium.webdriver.chrome.options import Options
        """Sets chrome options for Selenium.
        Chrome options for headless browser is enabled.
        """
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_prefs = {}
        chrome_options.experimental_options["prefs"] = chrome_prefs
        chrome_prefs["profile.default_content_settings"] = {"images": 2}
        return chrome_options
        
    #driver = webdriver.Remote("http://selenium:4444/wd/hub", options=webdriver.ChromeOptions())
    driver = webdriver.Chrome(options=set_chrome_options())
    driver.file_detector = LocalFileDetector()

    driver.get("https://www.nomerogram.ru/")
    driver.implicitly_wait(28.5)
    driver.maximize_window()


    #to identify element
    s = driver.find_element(By.XPATH,"//input[@type='file']")
    #file path specified with send_keys
    s.send_keys(filename)
    btn = driver.find_element(By.XPATH,"//button[@aria-label='upload']")
    btn.click()
    # uploaded, wait for refresh page
    WebDriverWait(driver, 6).until(EC.presence_of_element_located((By.XPATH, "//h3[contains(text(),'Загруж')]")))
    
    result = 'Загруж' in driver.page_source
  
    text_file = open("after-upload.htm", "w")
    n = text_file.write(driver.page_source)
    text_file.close()

    driver.close()
    driver.quit()
    return result

def argparser_prepare():

    class PrettyFormatter(argparse.ArgumentDefaultsHelpFormatter,
        argparse.RawDescriptionHelpFormatter):

        max_help_position = 35

    parser = argparse.ArgumentParser(description='Upload directory with images to nomerogram.ru',
            formatter_class=PrettyFormatter)

    parser.add_argument('path',  default=os.path.join(os.path.dirname(os.path.realpath(__file__)),'feeder','keep_direction'))


    return parser

parser = argparser_prepare()
args = parser.parse_args()

path = args.path
assert os.path.isdir(path)

dest_path = os.path.join(path,'nomerogram_uploaded')
if not os.path.isdir(dest_path):
    os.makedirs(dest_path)

total = 0
for dirpath, dnames, fnames in os.walk(path):
    for filename in fnames: 
        if not filename.lower().endswith('jpg'): continue
        if 'nomerogram_uploaded' in dirpath: continue
        total = total+1

with tqdm(total=total) as pbar:
    for dirpath, dnames, fnames in os.walk(path):
        for filename in fnames: 
            if not filename.lower().endswith('jpg'): continue
            if 'nomerogram_uploaded' in dirpath: continue
            
            pbar.write(filename)
            if not os.path.isfile(filename):
                print('file already deleted, continue to next')
                continue
            result = browser_upload(os.path.join(dirpath,filename))
            if result == True:
                shutil.move(os.path.join(dirpath,filename),dest_path)
            pbar.update(1)
            for j in trange(15*4, desc='upload ok, pause between uploads'):
                time.sleep(1/4)

