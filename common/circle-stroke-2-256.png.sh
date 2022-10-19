#!/bin/bash -e

magick -size 256x256 xc:transparent -fill None -stroke white -strokewidth 2 \
  -draw "arc 0.5,0.5 254.5,254.5 0,360" circle-stroke-2-256.png
