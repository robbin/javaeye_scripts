#!/bin/sh
# 作用：统计 production.log 里同时含 “200 OK” 和 /app/sub 或 /app/my_act 的行，第 17 列去重后的个数。
# 输入：无参数。读取当前目录的 production.log，个数打印到标准输出。
# 假设：第 17 列形如 [http://主机...]；会去掉 [http://，并截掉第一个点及之后的内容。这一列在业务上是不是用户名，仓库里没有样例，不能确定。

grep "200 OK" production.log | grep -E "/app/sub|/app/my_act" | awk '{print $17 }' | awk 'gsub(/\[http:\/\//,"") gsub(/\.(.*)/,"") {print $0}' | sort | uniq  | wc -l 
