#!/bin/sh

CPU_MAX=30

for TOPINFO in `top -b -n 1 -u webuser | grep node | awk '{print $1":"$9}'`
do
  PID=${TOPINFO%:*}
  CPU=${TOPINFO#*:}
  CPU=${CPU%.*}
  echo $PID $CPU
  if [ $CPU -ge $CPU_MAX ]; then
    echo
    echo `date`
    echo "----------------------------------------"
    echo "PID["$PID"]: CPU="$CPU"% is too high!"
    echo
    #kill $PID
  fi
done