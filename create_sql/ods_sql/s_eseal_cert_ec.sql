use ${hiveconf:ods_db};
create external table S_ESEAL_CERT_EC(
  `id` double, 
  `qz_id` double, 
  `zs_id` double, 
  `is_del` double, 
  `bd_gx` double, 
  `create_user` string, 
  `create_date` string, 
  `modify_user` string, 
  `modify_date` string, 
  `bd_sh_zt` double, 
  `db_sh_yj` string)
comment 'S_ESEAL_CERT_EC'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_ESEAL_CERT_EC";