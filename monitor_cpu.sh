#!/bin/sh
# 作用：查看 webuser 下 node 进程的 CPU，达到或超过 30% 时打印告警。
# 输入：无参数。不读文件，直接调用 top。
# 假设：top 支持 -b -n 1 -u webuser，CPU 占用在第 9 列；比较前会丢掉小数。kill 那一行是注释，脚本只打印，不结束进程。

CPU_MAX=30

for TOPINFO in $(top -b -n 1 -u webuser | grep node | awk '{print $1":"$9}')
do
  PID=${TOPINFO%:*}
  CPU=${TOPINFO#*:}
  CPU=${CPU%.*}
  echo "$PID" "$CPU"
  if [ "$CPU" -ge "$CPU_MAX" ]; then
    echo
    date
    echo "----------------------------------------"
    echo "PID[$PID]: CPU=$CPU% is too high!"
    echo
    #kill $PID
  fi
done