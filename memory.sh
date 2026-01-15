#!/bin/sh

grep "CONSUME MEMORY" production.log | grep -v "CONSUME MEMORY: 0" | grep -v "CONSUME MEMORY: -" | awk '{print $3 "\t" $6 "\t" $8 }' | sort -r -n | head -n 500 > m.log 
