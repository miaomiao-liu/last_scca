#!/bin/sh
source /etc/profile
hiveDB=$1 ## Hive database
hdfsDir=$2
## oracle1 connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
oracle1Connect=$oracle1_addr
oracle1User=$oracle1_user
oracle1Pwd=$oracle1_pwd
oracle1DB=$oracle1_DB 
oracle1TbAllUpdate=('CONFIG_APP' 'SYS_OFFICE' 'SYS_USER' 'WORK_CERT_INFO' 'WORK_COMPANY' 'WORK_COMPANY_HIS' 'WORK_USER' 'WORK_USER_HIS') ## The table in oracle1 need all update
oracle1TbIncUpdate=('IXIN_DATA' 'WORK_DEAL_INFO') ## The table in oracle1 need incremental update
## The direct of oracle1 log file and the last day
date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
oracle1Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
## All update table 
echo "==============================================================" >> ${oracle1Log}
echo "$`date "+%Y-%m-%d %H:%M:%S"` oracle1 data all update table begin" >> ${oracle1Log}
echo "--------------------------------------------------------------" >> ${oracle1Log}
for tb in ${oracle1TbAllUpdate[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${oracle1Log}
sqoop import --connect ${oracle1Connect}/${oracle1DB} \
             --username ${oracle1User} \
             --password ${oracle1Pwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} update succces to hdfs!!" >> ${oracle1Log}
    else
        echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle1Log};
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle1Log}
    else 
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${oracle1Log}
       exit 1; 
    fi
	## delete 2 days ago data in table
    if [ $? -eq 0 ]; then
	hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
	echo "table ${tb} data at ${date2day} already succes delete from  table" >> ${oracle1Log};
    else
	echo "table ${tb} data at ${date2day} failed delete from table" >> ${oracle1Log}
	exit 1; 
    fi   
done

echo "`date "+%Y-%m-%d %H:%M:%S"` oracle1 data all update table end" >> ${oracle1Log}
echo "==============================================================" >> ${oracle1Log}

## Incremental update table
echo "==============================================================" >> ${oracle1Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle1 incremental update table begin" >> ${oracle1Log}
echo "--------------------------------------------------------------" >> ${oracle1Log}
for tb in ${oracle1TbIncUpdate[@]}  
do  
    echo "begin incremental update table ${tb} data at ${date1day}" >> ${oracle1Log}
    sqoop import --connect ${oracle1Connect}/${oracle1DB}  \
             --username ${oracle1User} \
             --password ${oracle1Pwd} \
             -e "select * from ${tb} where to_char(CREATE_DATE,'yyyy-mm-dd')='${date1day}' and \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update succces !!" >> ${oracle1Log}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle1Log}
    	exit 1; ## If update failed, then end the shell script.
    fi 

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1

    ## update data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle1Log}
    else
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle1Log}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle1 data incremental update table end" >> ${oracle1Log}
echo "==============================================================" >> ${oracle1Log}



