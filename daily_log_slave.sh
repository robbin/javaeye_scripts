#!/bin/sh
# 作用：轮转本机 Rails 日志，并把副本 scp 到 iteye，供从库侧统计使用。
# 输入：无参数。
# 假设：工作目录 /home/webuser/log；源文件 ~/webroot/javaeye/log/production.log；
#       scp 目标 webuser@iteye:~/log/，端口 33033。会删除本地 production_slave.log，复制后把源日志截成空文件。

cd /home/webuser/log

rm -rf production_slave.log
cp ~/webroot/javaeye/log/production.log production_slave.log
: > ~/webroot/javaeye/log/production.log
scp -P 33033 production_slave.log webuser@iteye:~/log/
