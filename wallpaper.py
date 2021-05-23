#!/usr/bin/python

import os
import random
import time
import datetime

path = os.path.join(os.getcwd(), "/home/nick/wallpaper/wallpapers")
print(path)

# os.system('xrandr --output HDMI1 --auto --left-of eDP1')
os.system('xrandr --output HDMI1 --mode 1920x1080 --auto --left-of eDP1')

Lpath = os.path.join(path, "1920x1080")
img1 = os.path.join(Lpath, "cropped-1920-1080-84284.jpg")


Rpath = os.path.join(path, "1366x768")
img2 = os.path.join(Rpath, "cropped-1366-768-793604.jpg")


os.system("echo '' > error.log")
os.system("echo '============================' >> error.log")
os.system("echo '" + str(datetime.datetime.now()) + "' >> error.log")
os.system("echo '============================' >> error.log")
os.system("convert " + img1 + " " + img2 + " +append wallpaper.png 2>> error.log")
os.system("nitrogen --set-centered /home/nick/wallpaper.png --save 2>> error.log")

# while True:
#     Lpath = os.path.join(path, "1920x1080")
#     Limages = [f for f in os.listdir(Lpath) if os.path.isfile(os.path.join(Lpath, f))]
#     Limages = [os.path.join(Lpath, f) for f in Limages]
#     img1 = random.choice(Limages)
# 
#     Rpath = os.path.join(path, "1366x768")
#     Rimages = [f for f in os.listdir(Rpath) if os.path.isfile(os.path.join(Rpath, f))]
#     Rimages = [os.path.join(Rpath, f) for f in Rimages]
#     img2 = random.choice(Rimages)
# 
#     os.system("echo '' > error.log")
#     os.system("echo '============================' >> error.log")
#     os.system("echo '" + str(datetime.datetime.now()) + "' >> error.log")
#     os.system("echo '============================' >> error.log")
#     os.system("convert " + img1 + " " + img2 + " +append wallpaper.png 2>> error.log")
#     os.system("nitrogen --set-centered /home/nick/wallpaper.png --save 2>> error.log")
#     #time.sleep(1200)
#     time.sleep(15)
