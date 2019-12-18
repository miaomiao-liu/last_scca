#!/bin/sh
cd ${PWD%last_scca*}/last_scca/create_sql/ods_sql
hive -e "create database ods_db;"
filenames=$(ls *.sql)  
for file in ${filenames};
do  
   hive -hiveconf ods_hdfs='/scca/ods_hdfs' -hiveconf ods_db='ods_db' -f ${file} 
done
