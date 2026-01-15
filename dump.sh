#!/bin/sh

/opt/mysql5/bin/mysqldump -u javaeye --add-drop-table -q --single-transaction javaeye3 | gzip > javaeye3_`date +%Y%m%d`.sql.gz