#!/bin/sh
source /etc/profile
hiveDB=$1 ## Hive database
hdfsDir=$2
## oracle2 connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
oracle2Connect=$oracle2_addr
oracle2User=$oracle2_user
oracle2Pwd=$oracle2_pwd
oracle2DB=$oracle2_DB
oracle2TbAllUpdate=('S_CLIENT' 'S_PROJECTCONFIG') ## The table in oracle2 need all update
oracle2TbIncUpdate=('S_EVIDENCE') ## The table in oracle2 need incremental update
## The direct of oracle2 log file and the last day
date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
oracle2Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

## All update table 
echo "==============================================================" >> ${oracle2Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle2 data all update table begin" >> ${oracle2Log}
echo "--------------------------------------------------------------" >> ${oracle2Log}
for tb in ${oracle2TbAllUpdate[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${oracle2Log}
sqoop import --connect ${oracle2Connect}/${oracle2DB} \
             --username ${oracle2User} \
             --password ${oracle2Pwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} update succces to hdfs!!" >> ${oracle2Log}
    else
        echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle2Log};
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle2Log}
    else 
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${oracle2Log}
       exit 1; 
    fi
	## delete 2 days ago data in table
    if [ $? -eq 0 ]; then
	hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
	echo "table ${tb} data at ${date2day} already succes delete from  table" >> ${oracle2Log};
    else
	echo "table ${tb} data at ${date2day} failed delete from table" >> ${oracle2Log}
	exit 1; 
    fi   
done

echo "`date "+%Y-%m-%d %H:%M:%S"` oracle2 data all update table end" >> ${oracle2Log}
echo "==============================================================" >> ${oracle2Log}

## Incremental update table
echo "==============================================================" >> ${oracle2Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle2 incremental update table begin" >> ${oracle2Log}
echo "--------------------------------------------------------------" >> ${oracle2Log}
for tb in ${oracle2TbIncUpdate[@]}  
do  
    echo "begin incremental update table ${tb} data at ${date1day}" >> ${oracle2Log}
    sqoop import --connect ${oracle2Connect}/${oracle2DB}  \
             --username ${oracle2User} \
             --password ${oracle2Pwd} \
             -e "select * from ${tb} where to_char(CREATE_TIME,'yyyy-mm-dd')='${date1day}' and \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --map-column-java ORI_DATA=String,SIGNED_DATA=String,SRCUPLOADFILES=String,TIME_DATA=String \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update succces !!" >> ${oracle2Log}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle2Log}
    	exit 1; ## If update failed, then end the shell script.
    fi 

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1

    ## update data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle2Log}
    else
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle2Log}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle2 data incremental update table end" >> ${oracle2Log}
echo "==============================================================" >> ${oracle2Log}



