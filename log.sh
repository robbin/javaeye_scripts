#!/bin/sh
# 作用：轮转 Rails 日志和访问日志，压缩当天访问日志，并删除 14 天前的压缩包。
# 输入：无参数。
# 假设：路径为 ~/webroot/javaeye/log/production.log、~/log/、~/stat/server/visit.log。find 使用 GNU 的 -delete，按 ctime 超过 14 天删除 visit-*.log.gz。

rm -rf ~/log/production.log
cp ~/webroot/javaeye/log/production.log ~/log/production.log
: > ~/webroot/javaeye/log/production.log

cp ~/stat/server/visit.log ~/log/visit-"$(date +%Y%m%d)".log
: > ~/stat/server/visit.log
gzip ~/log/visit-"$(date +%Y%m%d)".log
find ~/log/ -name "visit-*.log.gz" -ctime +14 -delete
