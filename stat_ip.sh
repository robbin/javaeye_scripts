#!/bin/sh
# 作用：把 production.log 里 Processing 行的第 4 列按 IPv4 /24 归并（最后一段改为 0），计数后取前 200 名写入 stat_ip.log。
# 输入：无参数。读取当前目录的 production.log，覆盖写入 stat_ip.log。
# 假设：第 4 列是点分 IPv4。不是四段的值也会照样拼接，脚本不校验。

grep Processing production.log | awk '{print $4}' | awk -F'.' '{print $1"."$2"."$3".0"}' | sort | uniq -c | sort -r -n | head -n 200 > stat_ip.log 
