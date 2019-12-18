#!/bin/sh

source ${PWD%/last_scca*}/last_scca/script.config
ods_db=$ods_db_name
etl_db=$etl_db_name
cboard_db=$cboard_db_name

ods_hdfs="/scca/ods_hdfs/ods_db"
way=${PWD%/last_scca*}/last_scca/first_input
ods_first_way=${way}/ods_first
etl_first_way=${way}/etl_first
mid_first_way=${way}/mid_first
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
test_sh=${PWD%/last_scca*}/last_scca/test/exeSQL.sh
ods_check_sh=${PWD%/last_scca*}/last_scca/test/ods_test.sh
ods_check_way="ods_check_first"

# ods_first
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` ods first input begin" >> ${Log}
for file in $(ls ${ods_first_way}/*.sh)
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

# ods_check
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` ods check first begin" >> ${Log}
/bin/sh ${ods_check_sh} ${ods_check_way}
        if [ $? -eq 0 ];then
                echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_check_sh} succces!!" >> ${Log}
        else
                echo "`date "+%Y-%m-%d %H:%M:%S"` run ${ods_check_sh} failed, please check your code !!" >> ${Log}
                exit 1
        fi
echo "==========================================" >> ${Log}


# etl_first
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` etl first input begin" >> ${Log}
for file in $(ls ${etl_first_way}/*.sh)
do     
	/bin/sh ${file} ${ods_db} ${etl_db}
	if [ $? -eq 0 ];then
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} succces!!" >> ${Log}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} failed, please check your code !!" >> ${Log}
		exit 1
	fi
done
echo "==========================================" >> ${Log}

# etl_check
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` check first begin" >> ${Log}
/bin/sh ${test_sh}
	if [ $? -eq 0 ];then
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${test_sh} succces!!" >> ${Log}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${test_sh} failed, please check your code !!" >> ${Log}
		exit 1
	fi
echo "==========================================" >> ${Log}

# mid_first
echo "==========================================" >> ${Log}
echo "`date "+%Y-%m-%d %H:%M:%S"` mid first input begin" >> ${Log}
for file in $(ls ${mid_first_way}/*.sh)
do
	/bin/sh ${file} ${etl_db} ${cboard_db}
	if [ $? -eq 0 ];then
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} succces!!" >> ${Log}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` run ${file} failed, please check your code !!" >> ${Log}
		exit 1
	fi
done
echo "==========================================" >> ${Log}
