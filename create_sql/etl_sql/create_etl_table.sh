#!/bin/sh
cd ${PWD%last_scca*}/last_scca/create_sql/etl_sql
# hive -e "create database etl_db;"
filenames=$(ls *.sql)
for file in ${filenames};
do
  hive -hiveconf etl_hdfs='/scca/etl_hdfs' -hiveconf etl_db='default' -f ${file}
done

