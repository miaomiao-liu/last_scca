#!/bin/sh
source /etc/profile
hiveOdsDB=$1 ## 存放ods的hive库
hiveETLDB=$2 ##存放etl的hive库
increUpdate=('i_xin_dimension') #增量更新的表
etlSqlFile=${PWD%/last_scca*}/last_scca/insert_sql/etl_insert/
## The direct of single table allupdate log file a
date1day=$(date -d last-day "+%Y-%m-%d") 

updateETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

echo "==============================================================" >> ${updateETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` i_xin_dimension table update begin" >> ${updateETLLog}

for tb in ${increUpdate[@]}  
do  
    echo "begin update table ${tb} data at ${date1day}" >> ${updateETLLog}
        hadoop fs -rm -r /scca/etl_hdfs/etl_db/${tb}/ymd=${date1day}
	hive -e "use ${hiveETLDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    hive -hiveconf dbName=${hiveETLDB} -hiveconf ymd=${date1day} -hiveconf tbName=${tb} \
    -hiveconf odsDB=${hiveOdsDB} -f ${etlSqlFile}${tb}.sql >>${hiveLog} 2>&1
    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update succces to hive etl db!!" >> ${updateETLLog}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${updateETLLog};
    	exit 1; ## If update failed, then end the shell script.
    fi 
done
echo "`date "+%Y-%m-%d %H:%M:%S"` i_xin_dimension update scccess" >> ${updateETLLog}
echo "==============================================================" >> ${updateETLLog}
