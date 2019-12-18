#!/bin/sh
source /etc/profile
etl_db=$1
cboard_db=$2

midSqlFile=${PWD%/last_scca*}/last_scca/insert_sql/mid_insert/
cd ${midSqlFile}
midTable=$(ls *.sql)
updateETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log

date1day=$(date -d last-day "+%Y-%m-%d") 
date2day=$(date -d "2 days ago" "+%Y-%m-%d") 

echo "==============================================================" >> ${updateETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` cboard table begin" >> ${updateETLLog}
for file in ${midTable[@]}
do
	echo "begin ${file%.sql} data at ${date1day}" >> ${updateETLLog}
	hive -hiveconf etl_db=${etl_db} -hiveconf cboard_db=${cboard_db} -hiveconf ymd=${date1day} -f ${file} >>${hiveLog} 2>&1
	if [ $? -eq 0 ];then
    	echo "table ${file%.sql} data at ${date1day} insert succces to cboard db!!" >> ${updateETLLog}
    else 
    	echo "table ${file%.sql} data at ${date1day} insert failed, please check your code !!" >> ${updateETLLog};
    	exit 1; ## If update failed, then end the shell script.
    fi 

## drop 2 days age partition
    if [ $? -eq 0 ]; then
		hive -e "use ${cboard_db}; alter table ${file%.sql} drop partition(ymd='${date2day}');" >>${hiveLog} 2>&1
		echo "table ${file%.sql} data at ${date2day} already succes delete ！！" >> ${updateETLLog};
	else
		echo "table ${file%.sql} data at ${date2day} failed delete ！！" >> ${updateETLLog}
		exit 1; 
	fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"` cboard insert scccess" >> ${updateETLLog}
echo "==============================================================" >> ${updateETLLog}
