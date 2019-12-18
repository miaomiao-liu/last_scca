#!/bin/sh
source /etc/profile
updateShFile=${PWD%/last_scca*}/last_scca/update/ods_etl/
cd ${updateShFile}
ods_etl_sh=$(ls *.sh)
updateETLLog=${PWD%/last_scca*}/last_scca/log/mylog.log
ods_db=$1
etl_db=$2

echo "==============================================================" >> ${updateETLLog}
echo "`date "+%Y-%m-%d %H:%M:%S"` ods_etl_update begin" >> ${updateETLLog}
for file in ${ods_etl_sh};
do
  if [ ${file} != "ods_etl_update.sh" ];then
     echo "ods_etl_update ${file} begin update " >> ${updateETLLog}
     /bin/sh ${file} ${ods_db} ${etl_db}
  fi
done
echo "`date "+%Y-%m-%d %H:%M:%S"` ods_etl_update end" >> ${updateETLLog}
echo "==============================================================" >> ${updateETLLog}
