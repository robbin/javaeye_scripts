#!/bin/sh

cd /home/webuser/log

rm -rf production_slave.log
cp ~/webroot/javaeye/log/production.log production_slave.log
echo -n > ~/webroot/javaeye/log/production.log
scp -P 33033 production_slave.log webuser@iteye:~/log/
