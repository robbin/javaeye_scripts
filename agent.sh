#!/bin/sh
# 作用：从 production.log 抽出常见浏览器的 User-Agent，按出现次数从高到低写入 agent.log。
# 输入：无参数。读取当前目录的 production.log，覆盖写入 agent.log。
# 假设：日志里有以 HTTP_USER_AGENT 开头的行；只保留含 MSIE、Firefox、Chrome、Opera、Safari、Gecko 的行。

grep HTTP_USER_AGENT production.log  | grep -E 'MSIE|Firefox|Chrome|Opera|Safari|Gecko'  | sort | uniq -c | sort -r -n > agent.log
