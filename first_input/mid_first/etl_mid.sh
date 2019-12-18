#!/bin/sh
etl_db=$1
cboard_db=$2

midSqlFile=${PWD%/last_scca*}/last_scca/insert_sql/mid_insert/
cd ${midSqlFile}
midTable=$(ls *.sql)
updateETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

date1day=$(date -d last-day "+%Y-%m-%d") 
date2day=$(date -d "2 days ago" "+%Y-%m-%d") 

hadoop fs -rm -r /scca/cboard_hdfs/cboard_db
echo "==============================================================" >> ${updateETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` cboard table begin" >> ${updateETLLog}
for file in ${midTable[@]}
do

	echo "begin ${file%.sql} data at ${date1day}" >> ${updateETLLog}
        hive -e "use ${cboard_db}; alter table ${file%.sql} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
	hive -hiveconf etl_db=${etl_db} -hiveconf cboard_db=${cboard_db} -hiveconf ymd=${date1day} -f ${file} >>${hiveLog} 2>&1
	if [ $? -eq 0 ];then
    	echo "table ${file%.sql} data at ${date1day} insert success to cboard db!!" >> ${updateETLLog}
    else 
    	echo "table ${file%.sql} data at ${date1day} insert failed, please check your code !!" >> ${updateETLLog};
    	exit 1; ## If update failed, then end the shell script.
    fi 


done
echo "`date "+%Y-%m-%d %H:%M:%S"` cboard insert sccess" >> ${updateETLLog}
echo "==============================================================" >> ${updateETLLog}
