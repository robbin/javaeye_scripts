#!/bin/sh 

awk '{print $1}' visit.log | awk -F'.' '{print $1"."$2"."$3".0"}' | sort | uniq  > visit_ip.log 
