#!/bin/sh
way=${PWD%/last_scca*}/last_scca/create_sql
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log


# create table
echo ${date} >> ${Log}
echo "==========================================" >> ${Log}
for file in $(ls ${way}/*/*.sh);
do   
	date=$(date "+%Y-%m-%d %H:%M:%S")
	/bin/sh ${file}
	if [ $? -eq 0 ];then
        echo "${date} run ${file} succces!!" >> ${Log}
    else
        echo "${date} run ${file} failed, please check your code !!" >> ${Log}
        echo "==========================================" >> ${Log}
        exit 1;
    fi
done
hive -e "create database scca_etl_test;"
hive -e "create database scca_ods_test;"
echo "==========================================" >> ${Log}


