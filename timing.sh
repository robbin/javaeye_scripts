#!/bin/sh
# 作用：整理 200.log 的耗时，按总时间从高到低取前 1000 行写入 timing.log。
# 输入：无参数。读取当前目录的 200.log，覆盖写入 timing.log。
# 假设：200.log 不是本仓库里的脚本生成的，来源不清楚。awk 改写第 3、5、7 列（去掉 ms、逗号、右括号），再把第 3 列当总毫秒、第 5 列当 View、第 7 列当 DB、第 11 列当 URL。列对不上时输出会是错的。

awk 'sub(/ms/, "", $3) sub(/,/, "", $5) sub(/\)/, "", $7) {print $0}' 200.log | awk '{print $3 "ms\tView: " $5 "ms\tDB: " $7 "ms\t URL: " $11 }' | sort -r -g | head -n 1000 > timing.log

