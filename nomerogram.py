#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import os

def browser_upload(filename):

    assert os.path.isfile(filename)
    from selenium import webdriver
    from selenium.webdriver.common.keys import Keys
    from selenium.webdriver.common.by import By
    from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
    from selenium.webdriver.remote.file_detector import LocalFileDetector
    from selenium.webdriver.support import expected_conditions as EC
    driver = webdriver.Remote("http://selenium:4444/wd/hub", options=webdriver.ChromeOptions())
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
    print('uploaded, wait for refresh page')
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

    parser.add_argument('--path', dest='path', required=False, default=os.path.join(os.path.dirname(os.path.realpath(__file__)),'feeder','keep_direction'))


    return parser

parser = argparser_prepare()
args = parser.parse_args()

path = args.path
assert os.path.isdir(path)

for dirpath, dnames, fnames in os.walk(path):
    for filename in fnames:
        if not filename.lower().endswith('jpg'): continue
        print(filename)
        result = browser_upload(os.path.join(dirpath,filename))
        print(result)

