#!/bin/sh
source /etc/profile
hiveDB=$1
hdfsDir=$2
## sqlserver connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
rmdbsConnect=$sqlserver_addr
rmdbs_user=$sqlserver_user
rmdbs_pwd=$sqlserver_pwd
rmdbs_db=$sqlserver_DB
sqlserverTbAllUpdate=('project' 'customer_info' 'key_table')
sqlserverTbIncUpdate=('CertUpdate') ## The table in sqlserver need incremental update
## The direct of sqlserver log file and the last day
date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
sqlserverLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
## All update table 
echo "==============================================================" >> ${sqlserverLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver data all update table begin" >> ${sqlserverLog}
echo "--------------------------------------------------------------" >> ${sqlserverLog}
for tb in ${sqlserverTbAllUpdate[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${sqlserverLog}

sqoop import --connect "${rmdbsConnect};username=${rmdbs_user};password=${rmdbs_pwd};database=${rmdbs_db}" \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1 
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} update success to hdfs!!" >> ${sqlserverLog}
    else
        echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${sqlserverLog};
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already success update from hdfs to table" >> ${sqlserverLog}
    else 
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${sqlserverLog}
       exit 1; 
    fi
	## delete 2 days ago data in table
    if [ $? -eq 0 ]; then
	hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
	echo "table ${tb} data at ${date2day} already success delete from  table" >> ${sqlserverLog};
    else
	echo "table ${tb} data at ${date2day} failed delete from table" >> ${sqlserverLog}
	exit 1; 
    fi   
done

echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver data all update table end" >> ${sqlserverLog}
echo "==============================================================" >> ${sqlserverLog}


## Incremental update table
echo "==============================================================" >> ${sqlserverLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver incremental update table begin" >> ${sqlserverLog}
echo "--------------------------------------------------------------" >> ${sqlserverLog}
for tb in ${sqlserverTbIncUpdate[@]}  
do  
    echo "begin incremental update table ${tb} data at ${date1day}" >> ${sqlserverLog}
    sqoop import --connect "${rmdbsConnect};username=${rmdbs_user};password=${rmdbs_pwd};database=${rmdbs_db}" \
             -e "select * from ${tb} where CONVERT(varchar(30),AddInTime,23)='${date1day}' and \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update success !!" >> ${sqlserverLog}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${sqlserverLog}
    	exit 1; ## If update failed, then end the shell script.
    fi 

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1

    ## update data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already success update from hdfs to table" >> ${sqlserverLog}
    else
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${sqlserverLog}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` sqlserver data incremental update table end" >> ${sqlserverLog}
echo "==============================================================" >> ${sqlserverLog}


