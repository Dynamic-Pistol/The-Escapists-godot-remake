#!/bin/bash
for file in *.png; do
magick $file -filter point -resize 400% $file
done
#magick Icon-1.png -filter point -resize 400% Icons-1.png
