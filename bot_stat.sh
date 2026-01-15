#!/bin/sh

total=0
for i in `cat bot.log | awk '{print $1}' `
do
  total=`expr $total + $i`
done
echo $total
