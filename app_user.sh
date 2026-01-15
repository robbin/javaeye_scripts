#!/bin/sh

grep "200 OK" production.log | grep -E "/app/sub|/app/my_act" | awk '{print $17 }' | awk 'gsub(/\[http:\/\//,"") gsub(/\.(.*)/,"") {print $0}' | sort | uniq  | wc -l 
