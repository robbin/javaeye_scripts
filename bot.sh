#!/bin/sh 

#grep HTTP_USER_AGENT production.log | grep -v -E 'MSIE|Firefox|Chrome|Opera|Safari|Gecko' | sort | uniq -c | sort -r -n > bot.log 

grep HTTP_USER_AGENT production.log | grep -v MSIE | grep -v Firefox | grep -v Chrome | grep -v Opera | grep -v Safari | grep -v Gecko | sort | uniq -c | sort -r -n > bot.log
