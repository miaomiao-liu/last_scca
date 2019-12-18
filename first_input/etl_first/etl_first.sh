#!/bin/sh
##use/last_scca/insert_sql/etl_insert all etl sqls。
hiveOdsDB=$1 ## 存放ods的hive库
hiveETLDB=$2  ##存放etl的hive库
etlSqlFile=${PWD%/last_scca*}/last_scca/insert_sql/etl_insert/
cd ${etlSqlFile}
etl_sql=$(ls *.sql)

date1day=$(date -d last-day "+%Y-%m-%d")
firstETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

hadoop fs -rm -r /scca/etl_hdfs/etl_db

echo "==============================================================" >> ${firstETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first input for etl begin" >> ${firstETLLog}
for file in ${etl_sql};
do
 echo "${file%.sql} first input begin " >> ${firstETLLog}
  hive -e "use ${hiveETLDB}; alter table ${file%.sql} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
  hive -hiveconf dbName=${hiveETLDB} -hiveconf tbName=${file%.sql} \
  -hiveconf ymd=${date1day} -hiveconf odsDB=${hiveOdsDB} -f ${file} >> ${hiveLog} 2>&1 
echo "${file%.sql} first input success " >> ${firstETLLog}
done
echo "`date "+%Y-%m-%d %H:%M:%S"` first input for etl end" >> ${firstETLLog}
echo "==============================================================" >> ${firstETLLog}