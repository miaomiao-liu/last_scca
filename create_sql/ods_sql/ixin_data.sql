use ${hiveconf:ods_db};
create external table IXIN_DATA(
  `id` double, 
  `ie_version` string, 
  `access_time` string, 
  `access_type` string, 
  `cert_sn` string, 
  `cpu_id` string, 
  `create_date` string, 
  `del_flag` string, 
  `ixin_version` string, 
  `ip` string, 
  `key_sn` string, 
  `os_version` string, 
  `remarks` string, 
  `app_id` double)
comment 'IXIN_DATA'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/IXIN_DATA";