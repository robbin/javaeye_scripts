#!/bin/sh

grep HTTP_USER_AGENT production.log  | grep -E 'MSIE|Firefox|Chrome|Opera|Safari|Gecko'  | sort | uniq -c | sort -r -n > agent.log
