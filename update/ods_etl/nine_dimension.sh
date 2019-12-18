#!/bin/sh
source /etc/profile
hiveOdsDB=$1 ## 存放ods的hive库
hiveETLDB=$2 ##存放etl的hive库
## 九个维度表的更新
allupdateSingle=('client_dimension' 'customer_dimension' 'sys_office_dimension' 's_d_qzcs_dimension' 'cert_dimension' 'company_dimension' 'project_dimension' 'sys_user_dimension' 'user_dimension') # 全量更新的表的所有etl表
etlSqlFile=${PWD%/last_scca*}/last_scca/insert_sql/etl_insert/
## The direct of single table allupdate log file a
date1day=$(date -d last-day "+%Y-%m-%d") 
date2day=$(date -d "2 days ago" "+%Y-%m-%d")
updateETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

echo "==============================================================" >> ${updateETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` 9 dimensionTb update begin" >> ${updateETLLog}

for tb in ${allupdateSingle[@]} 
do  
    echo "begin update table ${tb} data at ${date1day}" >> ${updateETLLog}
        hadoop fs -rm -r /scca/etl_hdfs/etl_db/${tb}/ymd=${date1day}
	hive -e "use ${hiveETLDB}; alter table ${tb} drop if exists partition (ymd='${date1day}');" >> ${hiveLog} 2>&1
    hive -hiveconf dbName=${hiveETLDB} -hiveconf ymd=${date1day} -hiveconf tbName=${tb} -hiveconf odsDB=${hiveOdsDB} -f ${etlSqlFile}${tb}.sql >> ${hiveLog} 2>&1
    if [ $? -eq 0 ]
    then
    	echo "table ${tb} data at ${date1day} update succces to hive etl db!!" >> ${updateETLLog}
    else 
    	echo "table ${tb} data at ${date1day} update failed, please check your code !!" >> ${updateETLLog}
    	exit 1 ## If update failed, then end the shell script.
    fi 
    ##当date1day的数据更新完之后，删除数据表中的date2day的数据
    if [ $? -eq 0 ]
    then
		hive -e "use ${hiveETLDB}; alter table ${tb} drop partition(ymd='${date2day}');" >> ${hiveLog} 2>&1
		echo "table ${tb} data at ${date2day} already succes delete ！！" >> ${updateETLLog}
	else
		echo "table ${tb} data at ${date2day} failed delete ！！" >> ${updateETLLog}
		exit 1
	fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"` 9 dimensionTb update scccess" >> ${updateETLLog}
echo "==============================================================" >> ${updateETLLog}
