#!/bin/sh 
# 作用：把 visit.log 第一列按 IPv4 /24 归并（最后一段改为 0），去重后写入 visit_ip.log。
# 输入：无参数。读取当前目录的 visit.log，覆盖写入 visit_ip.log。
# 假设：第一列是点分 IPv4。这里只去重、不计数，和 stat_ip.sh 不同。

awk '{print $1}' visit.log | awk -F'.' '{print $1"."$2"."$3".0"}' | sort | uniq  > visit_ip.log 
