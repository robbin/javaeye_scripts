#!/bin/sh

cat 200.log | awk 'sub(/ms/, "", $3) sub(/,/, "", $5) sub(/\)/, "", $7) {print $0}' | awk '{print $3 "ms\tView: " $5 "ms\tDB: " $7 "ms\t URL: " $11 }' | sort -r -g | head -n 1000 > timing.log

