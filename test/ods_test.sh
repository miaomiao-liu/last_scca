source ${PWD%/last_scca*}/last_scca/script.config
ods_db=$ods_db_name
mysqlConnect=$mysql_addr
mysqlDB=$mysql_DB
mysqlUser=$mysql_user
mysqlPwd=$mysql_pwd
oracle1Connect=$oracle1_addr
oracle1DB=$oracle1_DB
oracle1User=$oracle1_user
oracle1Pwd=$oracle1_pwd
oracle2Connect=$oracle2_addr
oracle2DB=$oracle2_DB
oracle2User=$oracle2_user
oracle2Pwd=$oracle2_pwd
oracle3Connect=$oracle3_addr
oracle3DB=$oracle3_DB
oracle3User=$oracle3_user
oracle3Pwd=$oracle3_pwd
sqlserverConnect=$sqlserver_addr
sqlserverDB=$sqlserver_DB
sqlserverUser=$sqlserver_user
sqlserverPwd=$sqlserver_pwd
start_time=$startTime
end_time=$endTime
way=$1
createtable_sh=${PWD%/last_scca*}/last_scca/test/${way}
ods_first_way=${PWD%/last_scca*}/last_scca/first_input/ods_first
ods_update_way=${PWD%/last_scca*}/last_scca/update/origin_ods
ods_hdfs="/scca/ods_hdfs/ods_db"
date=$(date "+%Y-%m-%d %H:%M:%S")
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
date1day=$(date -d last-day "+%Y-%m-%d")

if [ "${start_time}" = 'null' ];then
        start_time='2000-01-01 00:00:00'
fi
if [ "${end_time}" = 'null' ];then
        end_time=${date1day}' 23:59:59'
fi

/bin/sh ${createtable_sh}/ods_mysql.sh ${mysqlConnect} ${mysqlDB} ${mysqlUser} ${mysqlPwd} ${ods_db} "${start_time}" "${end_time}"
if [ $? -eq 1 ];then
	echo "${date} mysql in origin-ods failed, try again !!" >> ${Log}
	if [ "${way}"="ods_check_first" ];then
		/bin/sh ${ods_first_way}/mysql_ods_first.sh ${ods_db} ${ods_hdfs}
	else
		/bin/sh ${ods_update_way}/mysql_ods_update.sh.sh ${ods_db} ${ods_hdfs}
	fi
fi


/bin/sh ${createtable_sh}/ods_oracle1.sh ${oracle1Connect} ${oracle1DB} ${oracle1User} ${oracle1Pwd} ${ods_db} "${start_time}" "${end_time}"
if [ $? -eq 1 ];then
	echo "${date} oracle1 in origin-ods failed, try again !!" >> ${Log}
	if [ "${way}"="ods_check_first" ];then
		/bin/sh ${ods_first_way}/oracle1_ods_first.sh ${ods_db} ${ods_hdfs}
	else
		/bin/sh ${ods_update_way}/oracle1_ods_update.sh.sh ${ods_db} ${ods_hdfs}
	fi
fi


/bin/sh ${createtable_sh}/ods_oracle2.sh ${oracle2Connect} ${oracle2DB} ${oracle2User} ${oracle2Pwd} ${ods_db} "${start_time}" "${end_time}"
if [ $? -eq 1 ];then
	echo "${date} oracle2 in origin-ods failed, try again !!" >> ${Log}
	if [ "${way}"="ods_check_first" ];then
		/bin/sh ${ods_first_way}/oracle2_ods_first.sh ${ods_db} ${ods_hdfs}
	else
		/bin/sh ${ods_update_way}/oracle2_ods_update.sh.sh ${ods_db} ${ods_hdfs}
	fi
fi


/bin/sh ${createtable_sh}/ods_oracle3.sh ${oracle3Connect} ${oracle3DB} ${oracle3User} ${oracle3Pwd} ${ods_db} "${start_time}" "${end_time}"
if [ $? -eq 1 ];then
	echo "${date} oracle3 in origin-ods failed, try again !!" >> ${Log}
	if [ "${way}"="ods_check_first" ];then
		/bin/sh ${ods_first_way}/oracle3_ods_first.sh ${ods_db} ${ods_hdfs}
	else
		/bin/sh ${ods_update_way}/oracle3_ods_update.sh.sh ${ods_db} ${ods_hdfs}
	fi
fi


/bin/sh ${createtable_sh}/ods_sqlserver.sh ${sqlserverConnect} ${sqlserverDB} ${sqlserverUser} ${sqlserverPwd} ${ods_db} "${start_time}" "${end_time}"
if [ $? -eq 1 ];then
	echo "${date} sqlserver in origin-ods failed, try again !!" >> ${Log}
	if [ "${way}"="ods_check_first" ];then
		/bin/sh ${ods_first_way}/sqlserver_ods_first.sh ${ods_db} ${ods_hdfs}
	else
		/bin/sh ${ods_update_way}/sqlserver_ods_update.sh.sh ${ods_db} ${ods_hdfs}
	fi
fi
