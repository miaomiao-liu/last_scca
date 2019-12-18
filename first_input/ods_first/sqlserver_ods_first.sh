#!/bin/sh
hiveDB=$1
hdfsDir=$2
## sqlserver connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
sqlserverConnect=$sqlserver_addr
sqlserverUser=$sqlserver_user
sqlserverPwd=$sqlserver_pwd
sqlserverDB=$sqlserver_DB
sqlserverTbAllUpdate=('project' 'customer_info' 'key_table') ## The table in sqlserver need all input
sqlserverTbIncUpdate=('CertUpdate') ## The table in sqlserver need incremental first input

date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
start_time="$startTime"
end_time="$endTime"

if [ "${start_time}" = 'null' ];then
	start_time='2000-01-01 00:00:00'
fi
if [ "${end_time}" = 'null' ];then
	end_time=${date1day}' 23:59:59'
fi

sqlserverLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

## begin first input sqlserver all table
echo "==============================================================" >> ${sqlserverLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first sqlserver data first input begin" >> ${sqlserverLog}
echo "--------------------------------------------------------------" >> ${sqlserverLog}
for tb in ${sqlserverTbAllUpdate[@]}
do
    echo "begin first input table ${tb} data at ${date1day}" >> ${sqlserverLog}
sqoop import --connect "${sqlserverConnect};username=${sqlserverUser};password=${sqlserverPwd};database=${sqlserverDB}" \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --delete-target-dir \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} first input success to hdfs!!" >> ${sqlserverLog}
    else
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${sqlserverLog}
        exit 1; ## If first input failed, then end the shell script.
    fi
    ##delete table partition where ymd <= date1day
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${sqlserverLog}
    else 
       echo "table ${tb} data at ${date1day} failed first input from hdfs to table" >> ${sqlserverLog}
       exit 1; 
    fi   
done
echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver data first input table end" >> ${sqlserverLog}
echo "==============================================================" >> ${sqlserverLog}

## Incremental first input table
echo "==============================================================" >> ${sqlserverLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first sqlserver first input incremental table begin" >> ${sqlserverLog}
echo "--------------------------------------------------------------" >> ${sqlserverLog}
for tb in ${sqlserverTbIncUpdate[@]}  
do  
    echo "begin incremental first input table ${tb} data at ${date1day}" >> ${sqlserverLog}
    sqoop import --connect "${sqlserverConnect};username=${sqlserverUser};password=${sqlserverPwd};database=${sqlserverDB}" \
	             -e "select * from ${tb} where CONVERT(varchar(30),AddInTime,120) <= '${end_time}' and CONVERT(varchar(30),AddInTime,120) >= '${start_time}' and \$CONDITIONS" \
	             -m 1 \
	             --target-dir ${hdfsDir}/${tb}/${date1day} \
	             --delete-target-dir \
	             --fields-terminated-by '\001' \
	             --lines-terminated-by '\n' \
	             --hive-drop-import-delims >> ${hiveLog} 2>&1

    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} first input success !!" >> ${sqlserverLog}
    else 
    	echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${sqlserverLog}
    	exit 1; ## If first input failed, then end the shell script.
    fi 
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## first input data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${sqlserverLog}
    else
    	echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${sqlserverLog}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver data first input incremental table end" >> ${sqlserverLog}
echo "==============================================================" >> ${sqlserverLog}

