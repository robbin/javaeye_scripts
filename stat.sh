#!/bin/sh
# 作用：统计 production.log 里含 “200 OK” 的行的第 11 列，按出现次数从高到低取前 500 行写入 stat.log。
# 输入：无参数。读取当前目录的 production.log，覆盖写入 stat.log。
# 假设：第 11 列是什么取决于线上日志格式。本仓库没有样例，不能确定它是 URL、耗时还是别的字段。

grep "200 OK" production.log | awk '{print $11}'|sort|uniq -c | sort -r -n | head -n 500 > stat.log

