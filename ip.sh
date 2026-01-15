#!/bin/sh

grep Processing production.log |awk '{print $4}'| sort | uniq  | wc -l 
