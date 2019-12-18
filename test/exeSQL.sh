# database name
source ${PWD%/last_scca*}/last_scca/script.config
hiveDB1='scca_etl_test'
hiveDB2=$etl_db_name
hiveDB3=$ods_db_name
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
ymd=$(date -d last-day "+%Y-%m-%d")

# cert_use_info
sql_file1=${PWD%/last_scca*}/last_scca/test/createmid_sql/cert_use_info_etl.sql
sql_file2=${PWD%/last_scca*}/last_scca/test/check_sql/cert_use_info_test.sql
etl_sh=${PWD%/last_scca*}/last_scca/update/ods_etl/cert_use_info.sh
count=1
while((count<=2))
do
	hive -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb2=$hiveDB2 -hiveconf ymd=$ymd -f $sql_file1 >> ${hiveLog} 2>&1
	rst=`hive -S -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb3=$hiveDB3 -f $sql_file2`
        rst=`echo $rst | cut -c1`
	if [ "${rst}" != "0" ];
	then
		echo "`date "+%Y-%m-%d %H:%M:%S"` cert_use_info result error!! try again!!" >> ${Log}
		/bin/sh ${etl_sh} ${hiveDB3} ${hiveDB2}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` cert_use_info success!!" >> ${Log}
		break
	fi
	let count+=1
done

# evidence_info
sql_file1=${PWD%/last_scca*}/last_scca/test/createmid_sql/evidence_info_etl.sql
sql_file2=${PWD%/last_scca*}/last_scca/test/check_sql/evidence_info_test.sql
etl_sh=${PWD%/last_scca*}/last_scca/update/ods_etl/evidence_info.sh
count=1
while((count<=2))
do
	hive -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb2=$hiveDB2 -hiveconf ymd=$ymd -f $sql_file1 >> ${hiveLog} 2>&1
	rst=`hive -S -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb3=$hiveDB3 -f $sql_file2`
        rst=`echo $rst | cut -c1`
        if [ "${rst}" != "0" ];
	then
		echo "`date "+%Y-%m-%d %H:%M:%S"` evidence_info result error!! try again!!" >> ${Log}
		/bin/sh ${etl_sh} ${hiveDB3} ${hiveDB2}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` evidence_info success!!" >> ${Log}
		break
	fi
	let count+=1
done

# work_deal_info
sql_file1=${PWD%/last_scca*}/last_scca/test/createmid_sql/work_deal_info_etl.sql
sql_file2=${PWD%/last_scca*}/last_scca/test/check_sql/work_deal_info_test.sql
etl_sh=${PWD%/last_scca*}/last_scca/update/ods_etl/work_deal_info.sh
count=1
while((count<=2))
do
	hive -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb2=$hiveDB2 -hiveconf ymd=$ymd -f $sql_file1 >> ${hiveLog} 2>&1
	rst=`hive -S -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb3=$hiveDB3 -f $sql_file2`
        rst=`echo $rst | cut -c1`
	if [ "${rst}" != "0" ];
	then
		echo "`date "+%Y-%m-%d %H:%M:%S"` work_deal_info result error!! try again!!" >> ${Log}
		/bin/sh ${etl_sh} ${hiveDB3} ${hiveDB2}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` work_deal_info success!!" >> ${Log}
		break
	fi
	let count+=1
done

# s_eseal_info
sql_file1=${PWD%/last_scca*}/last_scca/test/createmid_sql/s_eseal_info_etl.sql
sql_file2=${PWD%/last_scca*}/last_scca/test/check_sql/s_eseal_info_test.sql
etl_sh=${PWD%/last_scca*}/last_scca/update/ods_etl/s_eseal_info.sh
count=1
while((count<=2))
do
	hive -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb2=$hiveDB2 -hiveconf ymd=$ymd -f $sql_file1 >> ${hiveLog} 2>&1
	rst=`hive -S -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb3=$hiveDB3 -f $sql_file2`
        rst=`echo $rst | cut -c1`
	if [ "${rst}" != "0" ];
	then
		echo "`date "+%Y-%m-%d %H:%M:%S"` s_eseal_info result error!! try again!!" >> ${Log}
		/bin/sh ${etl_sh} ${hiveDB3} ${hiveDB2}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` s_eseal_info success!!" >> ${Log}
		break
	fi
	let count+=1
done


# sign_info
sql_file1=${PWD%/last_scca*}/last_scca/test/createmid_sql/sign_info_etl.sql
sql_file2=${PWD%/last_scca*}/last_scca/test/check_sql/sign_info_test.sql
etl_sh=${PWD%/last_scca*}/last_scca/update/ods_etl/sign_info.sh
count=1
while((count<=2))
do
	hive -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb2=$hiveDB2 -hiveconf ymd=$ymd -f $sql_file1 >> ${hiveLog} 2>&1
	rst=`hive -S -hiveconf hivedb1=$hiveDB1 -hiveconf hivedb3=$hiveDB3 -f $sql_file2`
        rst=`echo $rst | cut -c1`
	if [ "${rst}" != "0" ];
	then
		echo "`date "+%Y-%m-%d %H:%M:%S"` sign_info result error!! try again!!" >> ${Log}
		/bin/sh ${etl_sh} ${hiveDB3} ${hiveDB2}
	else
		echo "`date "+%Y-%m-%d %H:%M:%S"` sign_info success!!" >> ${Log}
		break
	fi
	let count+=1
done
