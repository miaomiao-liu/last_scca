#!/bin/sh
source /etc/profile
hiveDB=$1
hdfsDir=$2
## mysql connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
mysqlConnect=$mysql_addr
mysqlUser=$mysql_user
mysqlPwd=$mysql_pwd
mysqlDB=$mysql_DB 
mysqlTbAllUpdate=('sign_project') ## The table in mysql need all update
mysqlTbIncUpdate=('sign_evidence') ## The table in mysql need incremental update

date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")

mysqlLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hivelog=${PWD%/last_scca*}/last_scca/log/hivelog.log

## begin update mysql all table
echo "==============================================================" >> ${mysqlLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` mysql data all update begin" >> ${mysqlLog}
echo "--------------------------------------------------------------" >> ${mysqlLog}
for tb in ${mysqlTbAllUpdate[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${mysqlLog}
sqoop import --connect ${mysqlConnect}/${mysqlDB}  \
             --username ${mysqlUser} \
             --password ${mysqlPwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --delete-target-dir \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hivelog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} all input success to hdfs!!" >> ${mysqlLog}
    else
        echo "table ${tb} data at ${date1day} all input failed, please check your code !!" >> ${mysqlLog}
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hivelog} 2>&1

    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hivelog} 2>&1
       echo "table ${tb} data at ${date1day} already success update from hdfs to table" >> ${mysqlLog}
    else 
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${mysqlLog}
       exit 1; 
    fi   
    ## delate the date2day partition
    if [ $? -eq 0 ]; then
        hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hivelog} 2>&1
        echo "table ${tb} data at ${date2day} already success delete from  table" >> ${mysqlLog};
        else
        echo "table ${tb} data at ${date2day} failed delete from table" >> ${mysqlLog}
    exit 1; 
    fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"` mysql data all update table end" >> ${mysqlLog}
echo "==============================================================" >> ${mysqlLog}

## Incremental update table
echo "==============================================================" >> ${mysqlLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first mysql incremental update table begin" >> ${mysqlLog}
echo "--------------------------------------------------------------" >> ${mysqlLog}
for tb in ${mysqlTbIncUpdate[@]}  
do  
    echo "begin incremental update table ${tb} data at ${date1day}" >> ${mysqlLog}
    sqoop import --connect ${mysqlConnect}/${mysqlDB}  \
	             --username ${mysqlUser} \
	             --password ${mysqlPwd} \
	             -e "select * from ${tb} where date(create_time) = '${date1day}' and \$CONDITIONS" \
	             -m 1 \
	             --target-dir ${hdfsDir}/${tb}/${date1day} \
	             --delete-target-dir \
	             --fields-terminated-by '\001' \
	             --lines-terminated-by '\n' \
	             --hive-drop-import-delims >> ${hivelog} 2>&1

    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update success !!" >> ${mysqlLog}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${mysqlLog}
    	exit 1; ## If update failed, then end the shell script.
    fi 

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hivelog} 2>&1

    ## update data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hivelog} 2>&1
    	echo "table ${tb} data at ${date1day} already success update from hdfs to table" >> ${mysqlLog}
    else
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${mysqlLog}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` mysql data incremental update table end" >> ${mysqlLog}
echo "==============================================================" >> ${mysqlLog}
