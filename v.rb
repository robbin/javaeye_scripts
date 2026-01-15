#!/usr/bin/env ruby

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
