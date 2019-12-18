#!/bin/sh
source /etc/profile
hiveDB=$1 ## Hive database
hdfsDir=$2
## oracle3 connect ,conclude url/user/passwd/database/all table
source ${PWD%/last_scca*}/last_scca/script.config
oracle3Connect=$oracle3_addr
oracle3User=$oracle3_user
oracle3Pwd=$oracle3_pwd
oracle3DB=$oracle3_DB
oracle3TbAllUpdate=('S_D_QZCS' 'S_ESEAL_CERT_EC' 'S_ESEAL_CS') ## The table in oracle3 need all update
orcaleTbAllUpdate1=('S_ESEAL_CERT')
oracle3TbIncUpdate=('S_ESEAL') ## The table in oracle3 need incremental update
## The direct of oracle3 log file and the last day
date1day=$(date -d last-day "+%Y-%m-%d")
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
oracle3Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
## All update table 
echo "==============================================================" >> ${oracle3Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle3 data all update table begin" >> ${oracle3Log}
echo "--------------------------------------------------------------" >> ${oracle3Log}
for tb in ${oracle3TbAllUpdate[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${oracle3Log}
sqoop import --connect ${oracle3Connect}/${oracle3DB} \
             --username ${oracle3User} \
             --password ${oracle3Pwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} update succces to hdfs!!" >> ${oracle3Log}
    else
        echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle3Log};
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle3Log}
    else 
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${oracle3Log}
       exit 1; 
    fi
	## delete 2 days ago data in table
    if [ $? -eq 0 ]; then
	hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
	echo "table ${tb} data at ${date2day} already succes delete from  table" >> ${oracle3Log};
    else
	echo "table ${tb} data at ${date2day} failed delete from table" >> ${oracle3Log}
	exit 1; 
    fi   
done

for tb in ${oracle3TbAllUpdate1[@]}
do
    echo "begin update table ${tb} data at ${date1day}" >> ${oracle3Log}
sqoop import --connect ${oracle3Connect}/${oracle3DB} \
             --username ${oracle3User} \
             --password ${oracle3Pwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --map-column-java ZS_BASE64=String \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} update succces to hdfs!!" >> ${oracle3Log}
    else
        echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle3Log};
        exit 1; ## If update failed, then end the shell script.
    fi

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle3Log}
    else
       echo "table ${tb} data at ${date1day} failed update from hdfs to table" >> ${oracle3Log}
       exit 1;
    fi
        ## delete 2 days ago data in table
    if [ $? -eq 0 ]; then
        hive -e "use ${hiveDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
        echo "table ${tb} data at ${date2day} already succes delete from  table" >> ${oracle3Log};
    else
        echo "table ${tb} data at ${date2day} failed delete from table" >> ${oracle3Log}
        exit 1; 
    fi   
done
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle3 data all update table end" >> ${oracle3Log}
echo "==============================================================" >> ${oracle3Log}


## Incremental update table
echo "==============================================================" >> ${oracle3Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle3 incremental update table begin" >> ${oracle3Log}
echo "--------------------------------------------------------------" >> ${oracle3Log}
for tb in ${oracle3TbIncUpdate[@]}  
do  
    echo "begin incremental update table ${tb} data at ${date1day}" >> ${oracle3Log}
    sqoop import --connect ${oracle3Connect}/${oracle3DB}  \
             --username ${oracle3User} \
             --password ${oracle3Pwd} \
             -e "select * from ${tb} where to_char(CREATE_DATE,'yyyy-mm-dd')='${date1day}' and \$CONDITIONS" \
             -m 1 \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --delete-target-dir \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --map-column-java QZ_TP_GIF=String,QZ_TP_PNG=String \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
    	echo "table ${tb} data at ${date1day} update succces !!" >> ${oracle3Log}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle3Log}
    	exit 1; ## If update failed, then end the shell script.
    fi 

hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1

    ## update data from hdfs to partition table
    if [ $? -eq 0 ];then
    	hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
    	echo "table ${tb} data at ${date1day} already succes update from hdfs to table" >> ${oracle3Log}
    else
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${oracle3Log}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle3 data incremental update table end" >> ${oracle3Log}
echo "==============================================================" >> ${oracle3Log}




