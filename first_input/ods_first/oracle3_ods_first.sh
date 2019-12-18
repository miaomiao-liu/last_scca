#!/bin/sh
hiveDB=$1
hdfsDir=$2
## oracle connect ,conclude url/user/passwd/database/all table

source ${PWD%/last_scca*}/last_scca/script.config
oracleConnect=$oracle3_addr
oracleUser=$oracle3_user
oraclePwd=$oracle3_pwd
oracleDB=$oracle3_DB
oracleTbAllUpdate=('S_D_QZCS' 'S_ESEAL_CERT_EC' 'S_ESEAL_CS')  ## The table in oracle need all first input
oracleTbAllUpdate1=('S_ESEAL_CERT')
oracleTbIncUpdate=('S_ESEAL') ## The table in oracle need incremental first input

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

oracleLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

## begin first input oracle all table
echo "==============================================================" >> ${oracleLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first oracle data first input begin" >> ${oracleLog}
echo "--------------------------------------------------------------" >> ${oracleLog}
for tb in ${oracleTbAllUpdate[@]}
do
    echo "begin first input table ${tb} data at ${date1day}" >> ${oracleLog}
sqoop import --connect ${oracleConnect}/${oracleDB}  \
             --username ${oracleUser} \
             --password ${oraclePwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --delete-target-dir \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} first input success to hdfs!!" >> ${oracleLog}
    else
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${oracleLog}
        exit 1; ## If first input failed, then end the shell script.
    fi
    ##delete table partition where ymd <= date1day
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${oracleLog}
    else 
       echo "table ${tb} data at ${date1day} failed first input from hdfs to table" >> ${oracleLog}
       exit 1; 
    fi   
done

for tb in ${oracleTbAllUpdate1[@]}
do
    echo "begin first input table ${tb} data at ${date1day}" >> ${oracleLog}
sqoop import --connect ${oracleConnect}/${oracleDB}  \
             --username ${oracleUser} \
             --password ${oraclePwd} \
             -e "select * from ${tb} where \$CONDITIONS" \
             -m 1 \
             --delete-target-dir \
             --target-dir ${hdfsDir}/${tb}/${date1day} \
             --fields-terminated-by '\001' \
             --lines-terminated-by '\n' \
             --map-column-java ZS_BASE64=String \
             --hive-drop-import-delims >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} first input success to hdfs!!" >> ${oracleLog}
    else
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${oracleLog}
        exit 1; ## If first input failed, then end the shell script.
    fi
    ## delete table partition where ymd <= date1day
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## Put the hdfs data to partition table
    if [ $? -eq 0 ];then
       hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
       echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${oracleLog}
    else
       echo "table ${tb} data at ${date1day} failed first input from hdfs to table" >> ${oracleLog}
       exit 1;
    fi  
done
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle data all first input table end" >> ${oracleLog}
echo "==============================================================" >> ${oracleLog}

## Incremental first input table
echo "==============================================================" >> ${oracleLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` first oracle incremental first input table begin" >> ${oracleLog}
echo "--------------------------------------------------------------" >> ${oracleLog}
for tb in ${oracleTbIncUpdate[@]}  
do  
    echo "begin incremental first input table ${tb} data at ${date1day}" >> ${oracleLog}
    sqoop import --connect ${oracleConnect}/${oracleDB}  \
                 --username ${oracleUser} \
                 --password ${oraclePwd} \
                 -e "select * from ${tb} where to_char(CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') <= '${end_time}' and to_char(CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') >= '${start_time}' and \$CONDITIONS" \
                 -m 1 \
                 --target-dir ${hdfsDir}/${tb}/${date1day} \
                 --delete-target-dir \
                 --fields-terminated-by '\001' \
                 --lines-terminated-by '\n' \
                 --map-column-java QZ_TP_GIF=String,QZ_TP_PNG=String \
                 --hive-drop-import-delims >> ${hiveLog} 2>&1

    if [ $? -eq 0 ];then
        echo "table ${tb} data at ${date1day} first input success !!" >> ${oracleLog}
    else 
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${oracleLog}
        exit 1; ## If first input failed, then end the shell script.
    fi 
    hive -e "use ${hiveDB}; alter table ${tb} drop if exists partition (ymd<='${date1day}');" >> ${hiveLog} 2>&1
    ## first input data from hdfs to partition table
    if [ $? -eq 0 ];then
        hive -e "use ${hiveDB}; alter table ${tb} add partition(ymd='${date1day}') location '${hdfsDir}/${tb}/${date1day}';" >> ${hiveLog} 2>&1
        echo "table ${tb} data at ${date1day} already success first input from hdfs to table" >> ${oracleLog}
    else
        echo "table ${tb} data at ${date1day} first input failed, please check your code !!" >> ${oracleLog}
    fi
done 
echo "`date "+%Y-%m-%d %H:%M:%S"` oracle data first input incremental table end" >> ${oracleLog}
echo "==============================================================" >> ${oracleLog}
