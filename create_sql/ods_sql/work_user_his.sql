use ${hiveconf:ods_db};
create external table WORK_USER_HIS(
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
  `status` bigint, 
  `user_sn` string, 
  `work_type` bigint, 
  `company_his_id` double)
comment 'WORK_USER_HIS'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/WORK_USER_HIS";