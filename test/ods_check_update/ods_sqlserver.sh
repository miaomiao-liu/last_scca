# sqlserver原始库链接
sqlserverConnect=$1
# sqlserver原始库数据库
sqlserverDB=$2
# sqlserver原始库用户名
sqlserverUser=$3
# sqlserver原始库密码
sqlserverPwd=$4
# ods数据库
ods_db=$5
# hive数据库
hivedb=scca_ods_test
# hdfs文件路径
hdfsDir=/scca/ods_check
# 原始库中需要验证的表
table_name_sqlserver=('project' 'customer_info' 'key_table')
table_name_sqlserver_ymd=('CertUpdate')
Log=${PWD%/last_scca*}/last_scca/log/mylog.log
hiveLog=${PWD%/last_scca*}/last_scca/log/hivelog.log
date1day=$(date -d last-day "+%Y-%m-%d")
count=0

date=$(date "+%Y-%m-%d %H:%M:%S")
echo "${date} Check ods get number" >> ${Log}
echo "==========================================" >> ${Log}
for tb in ${table_name_sqlserver[@]}
do
	date=$(date "+%Y-%m-%d %H:%M:%S")
	sqoop import --connect "${sqlserverConnect};username=${sqlserverUser};password=${sqlserverPwd};database=${sqlserverDB}" \
            -e "select count(*) as num from ${tb} where \$CONDITIONS" \
            -m 1 \
            --delete-target-dir \
            --target-dir ${hdfsDir}/${tb} \
            --fields-terminated-by '\001' \
            --lines-terminated-by '\n' \
            --hive-drop-import-delims >> ${hiveLog} 2>&1
    hive -e "DROP TABLE IF EXISTS ${hivedb}.${tb};" >> ${hiveLog} 2>&1
    hive -e "CREATE TABLE ${hivedb}.${tb}(num int);" >> ${hiveLog} 2>&1
    hive -e "load data inpath '${hdfsDir}/${tb}/*' into table ${hivedb}.${tb};" >> ${hiveLog} 2>&1
	if [ $? -eq 0 ];then
		echo "${date} get ${tb} succces!!" >> ${Log}
	else
        echo "${date} get ${tb} failed, please check your code !!" >> ${Log}
        echo "==========================================" >> ${Log}
        exit 1
    fi
    ods_number=`hive -S -e "select count(*) from ${ods_db}.${tb}"`
    origin_number=`hive -S -e "select * from ${hivedb}.${tb}"`
    ods_number=`echo "$ods_number" | head -n 1`
    origin_number=`echo "$origin_number" | head -n 1`
    echo "ods:${ods_number} origin:${origin_number}" >> ${Log}
    if [ "${ods_number}" != "${origin_number}" ];then
        count=1
    fi
done

for tb in ${table_name_sqlserver_ymd[@]}
do
    date=$(date "+%Y-%m-%d %H:%M:%S")
    sqoop import --connect "${sqlserverConnect};username=${sqlserverUser};password=${sqlserverPwd};database=${sqlserverDB}" \
            -e "select count(*) as num from ${tb} where CONVERT(varchar(30),AddInTime,23)='${date1day}' and \$CONDITIONS" \
            -m 1 \
            --delete-target-dir \
            --target-dir ${hdfsDir}/${tb} \
            --fields-terminated-by '\001' \
            --lines-terminated-by '\n' \
            --hive-drop-import-delims >> ${hiveLog} 2>&1
    hive -e "DROP TABLE IF EXISTS ${hivedb}.${tb};" >> ${hiveLog} 2>&1
    hive -e "CREATE TABLE ${hivedb}.${tb}(num int);" >> ${hiveLog} 2>&1
    hive -e "load data inpath '${hdfsDir}/${tb}/*' into table ${hivedb}.${tb};" >> ${hiveLog} 2>&1
    if [ $? -eq 0 ];then
        echo "${date} get ${tb} succces!!" >> ${Log}
    else
        echo "${date} get ${tb} failed, please check your code !!" >> ${Log}
        echo "==========================================" >> ${Log}
        exit 1
    fi
    ods_number=`hive -S -e "select count(*) from ${ods_db}.${tb} where ymd='${date1day}'"`
    origin_number=`hive -S -e "select * from ${hivedb}.${tb}"`
    ods_number=`echo "$ods_number" | head -n 1`
    origin_number=`echo "$origin_number" | head -n 1`
    echo "ods:${ods_number} origin:${origin_number}" >> ${Log}
    if [ "${ods_number}" != "${origin_number}" ];then
        count=1
    fi
done
echo "==========================================" >> ${Log}
exit ${count}