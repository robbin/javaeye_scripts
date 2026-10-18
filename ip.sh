#!/bin/sh
# 作用：统计 production.log 中 Processing 行第 4 列的不重复个数。
# 输入：无参数。读取当前目录的 production.log，个数打印到标准输出。
# 假设：按常见 Rails 日志，第 4 列多半是客户端 IP，但本仓库没有样例日志，不能完全确定。

grep Processing production.log |awk '{print $4}'| sort | uniq  | wc -l 
