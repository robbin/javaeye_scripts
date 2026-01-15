#!/bin/sh

cat production.log |grep "200 OK" | awk '{print $11}'|sort|uniq -c | sort -r -n | head -n 500 > stat.log

