#!/bin/sh
hiveDB=$1
hdfsDir=$2
## mysql connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
mysqlConnect=$mysql_addr
mysqlUser=$mysql_user
mysqlPwd=$mysql_pwd
mysqlDB=$mysql_DB ## Mysql database
mysqlTbAllUpdate=('sign_project') ## The table in mysql need all first input
mysqlTbIncUpdate=('sign_evidence') ## The table in mysql need incremental first input

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

mysqlLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

## begin first input mysql all table
echo "==============================================================" >> ${mysqlLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first mysql data first input begin" >> ${mysqlLog}
echo "--------------------------------------------------------------" >> ${mysqlLog}
for tb in ${mysqlTbAllUpdate[@]}
do
    echo "table ${tb} data at ${date1day} first input begin" >> ${mysqlLog}
sqoop import --connect ${mysqlConnect}/${mysqlDB}  \
             --username ${mysqlUser} \
             --password ${mysqlPwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --delete-target-dir \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} first input success to hdfs!!" >> ${mysqlLog}
    else
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${mysqlLog}
        exit 1; ## If first input failed, then end the shell script.
    fi
    ## delete table partition where ymd <= date1day
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${mysqlLog}
    else 
       echo "table ${tb} data at ${date1day} failed first input from hdfs to table" >> ${mysqlLog}
       exit 1; 
    fi   
done
echo "`date "+%Y-%m-%d %H:%M:%S"` mysql data all first input table end" >> ${mysqlLog}
echo "==============================================================" >> ${mysqlLog}

## Incremental first input table
echo "==============================================================" >> ${mysqlLog}
echo "${date1day} first mysql incremental first input table begin" >> ${mysqlLog}
echo "--------------------------------------------------------------" >> ${mysqlLog}
for tb in ${mysqlTbIncUpdate[@]}  
do 
    echo "begin incremental first input table ${tb} data at ${date1day}" >> ${mysqlLog}
    sqoop import --connect ${mysqlConnect}/${mysqlDB}  \
	             --username ${mysqlUser} \
	             --password ${mysqlPwd} \
	             -e "select * from ${tb} where create_time <= '${end_time}' and create_time >= '${start_time}' and \$CONDITIONS" \
	             -m 1 \
	             --target-dir ${hdfsDir}/${tb}/${date1day} \
	             --delete-target-dir \
	             --fields-terminated-by '\001' \
	             --lines-terminated-by '\n' \
	             --hive-drop-import-delims >> ${hiveLog} 2>&1

    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} first input success !!" >> ${mysqlLog}
    else 
    	echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${mysqlLog}
    	exit 1; ## If first input failed, then end the shell script.
    fi 
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## first input data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${mysqlLog}
    else
    	echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${mysqlLog}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` mysql data first input incremental table end" >> ${mysqlLog}
echo "==============================================================" >> ${mysqlLog}

