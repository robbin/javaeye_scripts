#!/bin/bash
# 作用：统计 production.log 的状态码和独立 IP 数，写成简短日报，邮件发给 fankai@gmail.com。
# 输入：无参数。在 /home/webuser/log 读取 production.log；production_db.log 非空时先追加进 production.log，统计后删除 production_db.log。
# 假设：需要 GNU date -d 和 mail，统计日期是昨天。没有设置 set -euo pipefail：grep 无匹配时退出码为 1，计数为 0 也会让 set -e 中止脚本。

export LC_CTYPE=en_US.UTF-8

cd /home/webuser/log
yesterday=$(date -d "-1 day" +%Y-%m-%d)

if [ -s production_db.log ]; then
  cat production_db.log >> production.log
fi

grep Completed production.log > all.log
request_all=$(cat all.log | wc -l)
request_200=$(grep -c "200 OK" all.log)
request_301=$(grep -c "301 Moved Permanently" all.log)
request_302=$(grep -c "302 Found" all.log)
request_304=$(grep -c "304 Not Modified" all.log)
request_401=$(grep -c "401 Unauthorized" all.log)
request_403=$(grep -c "403 Forbidden" all.log)
request_404=$(grep -c "404 Not Found" all.log)
request_ip=$(grep Processing production.log |awk '{print $4}'| sort | uniq  | wc -l)
rm all.log
rm production_db.log

cat > daily_log_report.log << EOF

$yesterday

所有IP       : $request_ip
所有请求     : $request_all
200正常访问  : $request_200
301永久转向  : $request_301
302临时转向  : $request_302
304未改变    : $request_304
401待验证    : $request_401
403禁止访问  : $request_403
404找不到    : $request_404

EOF
mail -s "daily log report" "fankai@gmail.com" < daily_log_report.log
exit 0
