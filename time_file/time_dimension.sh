#/bin/sh
etl_db='default'
start_time='2021-01-01 00:00' #'yyyy-mm-dd hh:mm'
end_time='2021-01-01 00:20'  #'yyyy-mm-dd hh:m'
time_path=${PWD%/last_scca*}/last_scca/time_file
rm ${time_path}"/time_dimension.txt"
python get_time_dimension.py "${start_time}" "${end_time}" "${time_path}"
## load time_dimension to etl_db.time_dimension
cd ${time_path}
hive -e "use ${etl_db};load data local inpath 'time_dimension.txt' into table time_dimension;"
