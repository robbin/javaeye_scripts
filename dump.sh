#!/bin/sh
# 作用：导出 javaeye3 并 gzip 到当前目录，文件名带当天日期。
# 输入：无参数。写入 javaeye3_YYYYMMDD.sql.gz。
# 假设：使用 /opt/mysql5/bin/mysqldump，用户 javaeye，库 javaeye3。命令行没有密码，能否连上取决于本机 MySQL 配置，仓库里看不出来。

/opt/mysql5/bin/mysqldump -u javaeye --add-drop-table -q --single-transaction javaeye3 | gzip > "javaeye3_$(date +%Y%m%d).sql.gz"