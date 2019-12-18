use ${hiveconf:ods_db};
create external table WORK_USER(
  `id` double, 
  `address` string, 
  `con_cert_number` string, 
  `con_cert_type` string, 
  `contact_email` string, 
  `contact_name` string, 
  `contact_phone` string, 
  `contact_sex` string, 
  `contact_tel` string, 
  `department` string, 
  `source` bigint, 
  `status` int, 
  `user_sn` string, 
  `work_type` int, 
  `company_id` double, 
  `contact_name_old` string)
comment 'WORK_USER'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/WORK_USER";