#!/bin/sh
# 作用：从 production.log 抽出内存消耗记录，去掉 0 和负数，按数值从大到小取前 500 行写入 m.log。
# 输入：无参数。读取当前目录的 production.log，覆盖写入 m.log。
# 假设：行内包含 “CONSUME MEMORY”，输出保留第 3、6、8 列。这三列分别是什么，仓库里没有说明。

grep "CONSUME MEMORY" production.log | grep -v "CONSUME MEMORY: 0" | grep -v "CONSUME MEMORY: -" | awk '{print $3 "\t" $6 "\t" $8 }' | sort -r -n | head -n 500 > m.log 
