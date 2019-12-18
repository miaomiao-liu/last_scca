#!/bin/sh
source /etc/profile
source ${PWD%/last_scca*}/last_scca/script.config
ods_db=$ods_db_name
etl_db=$etl_db_name
cboard_db=$cboard_db_name
ods_hdfs="/scca/ods_hdfs/ods_db"
way=${PWD%/last_scca*}/last_scca/update
origin_ods_way=${way}/origin_ods
ods_etl_way=${way}/ods_etl
etl_mid_way=${way}/etl_mid
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
test_sh=${PWD%/last_scca*}/last_scca/test/exeSQL.sh
ods_check_sh=${PWD%/last_scca*}/last_scca/test/ods_test.sh
ods_check_way="ods_check_update"

# origin_ods
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` ods update begin" >> ${Log}
for file in $(ls ${origin_ods_way}/*.sh)
do
	/bin/sh ${file} ${ods_db} ${ods_hdfs}
	if [ $? -eq 0 ];then
        	echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} succces!!" >> ${Log}
	else
       		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} failed, please check your code !!" >> ${Log}
        	exit 1
    	fi
done
echo "==========================================" >> ${Log}

#ods_check
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` ods check begin" >> ${Log}
/bin/sh ${ods_check_sh} ${ods_check_way}
        if [ $? -eq 0 ];then
                echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_check_sh} succces!!" >> ${Log}
        else
                echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_check_sh} failed, please check your code !!" >> ${Log}
                exit 1
        fi
echo "==========================================" >> ${Log}

# ods_etl
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` etl update begin" >> ${Log}
/bin/sh ${ods_etl_way}/ods_etl_update.sh ${ods_db} ${etl_db}
if [ $? -eq 0 ];then
       	echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_etl_way}/ods_etl_update.sh  succces!!" >> ${Log}
else
       	echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_etl_way}/ods_etl_update.sh failed, please check your code !!" >> ${Log}
       	echo "==========================================" >> ${Log}
       	exit 1
fi
echo "==========================================" >> ${Log}

# check
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` check begin" >> ${Log}
/bin/sh ${test_sh}
if [ $? -eq 0 ];then
	echo "`date "+%Y-%m-%d %H:%M:%S"` run ${test_sh} succces!!" >> ${Log}
else
	echo "`date "+%Y-%m-%d %H:%M:%S"` run ${test_sh} failed, please check your code !!" >> ${Log}
	exit 1
fi
echo "==========================================" >> ${Log}


# etl_mid
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` mid update begin" >> ${Log}
for file in $(ls ${etl_mid_way}/etl_mid.sh)
do
	/bin/sh ${file} ${etl_db} ${cboard_db}
	if [ $? -eq 0 ];then
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} succces!!" >> ${Log}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} failed, please check your code !!" >> ${Log}
		exit 1;
	fi
done
echo "==========================================" >> ${Log}
