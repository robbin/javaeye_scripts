#!/bin/sh

grep Processing production.log | awk '{print $4}' | awk -F'.' '{print $1"."$2"."$3".0"}' | sort | uniq -c | sort -r -n | head -n 200 > stat_ip.log 
