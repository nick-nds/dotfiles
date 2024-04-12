#!/bin/sh

# change size of all images in the directory ./overlap to 320px anf height auto

for img in $(ls overlap); do
    convert overlap/$img -resize 320x overlay/$img
    # convert lockscreen.png chosen.png -gravity center -composite lockscreen.png
done

