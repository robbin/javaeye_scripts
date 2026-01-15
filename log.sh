#!/bin/sh

rm -rf ~/log/production.log
cp ~/webroot/javaeye/log/production.log ~/log/production.log
echo -n > ~/webroot/javaeye/log/production.log

cp ~/stat/server/visit.log ~/log/visit-`date +%Y%m%d`.log
echo -n > ~/stat/server/visit.log
gzip ~/log/visit-`date +%Y%m%d`.log
find ~/log/ -name "visit-*.log.gz" -ctime +14 -delete
