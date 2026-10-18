#!/bin/sh
# 作用：把 agent.log 第一列的次数加总，打印到标准输出。
# 输入：无参数。读取当前目录的 agent.log。
# 假设：第一列是整数，通常由 agent.sh 生成。按空白分词后逐个相加。文件不存在或没有数字时打印 0。

total=0
for i in $(awk '{print $1}' agent.log)
do
  total=$(expr $total + $i)
done
echo "$total"
