#!/usr/bin/env ruby
# 作用：把 production.log 里 Processing、HTTP_USER_AGENT、HTTP_REFERER、Completed 几类行的部分字段接在同一行，打印到标准输出。
# 输入：无参数。只读当前目录的 production.log。
# 假设：按空白分词。Processing 取第 4 个字段；User-Agent 和 Referer 打印去掉首尾空白的整行；Completed 取第 17 个字段。这些字段在线上日志里具体代表什么，仓库里没有样例，无法进一步确认。

f = File.open("production.log")
while (line = f.gets) != nil do
  token = line.split
  if token && token[0] && ["Processing", "HTTP_USER_AGENT", "HTTP_REFERER", "Completed"].include?(token[0])
    if token[0] == "Processing" && token[3]
      print "\n#{token[3]} ";  next
    end
    if token[0] == "HTTP_USER_AGENT" && token[1]
      print "#{line.strip} "; next
    end
    if token[0] == "HTTP_REFERER" && token[1]
      print "#{line.strip} "; next
    end
    if token[0] == "Completed" && token[16]
      print token[16].strip; next
    end
  end
end
f.close
