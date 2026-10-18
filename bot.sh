#!/bin/sh 
# 作用：从 production.log 抽出不含常见浏览器关键字的 User-Agent，按出现次数从高到低写入 bot.log。
# 输入：无参数。读取当前目录的 production.log，覆盖写入 bot.log。
# 假设：日志里有 HTTP_USER_AGENT 行，排除 MSIE、Firefox、Chrome、Opera、Safari、Gecko。文件里另有一行已注释的 grep -E 写法，实际生效的是连续的 grep -v。这些行是不是爬虫，脚本没有写明。

#grep HTTP_USER_AGENT production.log | grep -v -E 'MSIE|Firefox|Chrome|Opera|Safari|Gecko' | sort | uniq -c | sort -r -n > bot.log 

grep HTTP_USER_AGENT production.log | grep -v MSIE | grep -v Firefox | grep -v Chrome | grep -v Opera | grep -v Safari | grep -v Gecko | sort | uniq -c | sort -r -n > bot.log
