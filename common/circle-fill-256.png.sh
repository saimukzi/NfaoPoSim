#!/bin/bash -e

magick -size 256x256 xc:transparent -fill white \
  -draw "arc 0,0 255,255 0,360" circle-fill-256.png
