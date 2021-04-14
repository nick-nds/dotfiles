#!/usr/bin/python

import os
import random
import time
import datetime

path = os.path.join(os.getcwd(), "/home/nick/wallpaper/wallpapers")
print(path)

os.system('xrandr --output HDMI1 --auto --left-of eDP1')

while True:
    images = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
    images = [os.path.join(path, f) for f in images]
    img1 = random.choice(images)
    images.remove(img1)
    img2 = random.choice(images)

    os.system("echo '' > error.log")
    os.system("echo '============================' >> error.log")
    os.system("echo '" + str(datetime.datetime.now()) + "' >> error.log")
    os.system("echo '============================' >> error.log")
    os.system("convert " + img1 + " " + img2 + " +append wallpaper.png 2>> error.log")
    os.system("nitrogen --set-auto wallpaper.png --save 2>> error.log")
    # time.sleep(1200)
    time.sleep(15)
