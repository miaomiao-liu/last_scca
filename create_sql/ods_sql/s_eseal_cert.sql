use ${hiveconf:ods_db};
create external table S_ESEAL_CERT(
  `id` double, 
  `qz_zs_id` string, 
  `create_date` string, 
  `create_user` string, 
  `modify_date` string, 
  `modify_user` string, 
  `zs_cn` string, 
  `zs_dn` string, 
  `zs_zt` double, 
  `zs_base64` string, 
  `is_del` double, 
  `qz_zs_pid` string, 
  `proj_id` string, 
  `key_number` string)
comment 'S_ESEAL_CERT'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_ESEAL_CERT";