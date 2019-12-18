#!/bin/sh
cd ${PWD%last_scca*}/last_scca/create_sql/mid_sql
hive -e "create database cboard_db;"
filenames=$(ls *.sql)  
for file in ${filenames};
do  
   hive -hiveconf cboard_hdfs='/scca/cboard_hdfs' -hiveconf cboard_db='cboard_db' -f ${file} 
done
