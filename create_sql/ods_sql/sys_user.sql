use ${hiveconf:ods_db};
create external table SYS_USER(
  `id` double, 
  `company_id` double, 
  `office_id` double, 
  `login_name` string, 
  `password` string, 
  `no` string, 
  `name` string, 
  `email` string, 
  `phone` string, 
  `mobile` string, 
  `user_type` string, 
  `login_ip` string, 
  `login_date` string, 
  `create_by` double, 
  `create_date` string, 
  `update_by` double, 
  `update_date` string, 
  `remarks` string, 
  `del_flag` string, 
  `balance_type` bigint, 
  `classificationd` string, 
  `company_address` string, 
  `compay` string, 
  `cp_type` bigint, 
  `description` string, 
  `discp_id` string, 
  `im` string, 
  `is_report` bigint, 
  `is_split` bigint, 
  `msg_type` string, 
  `parent_id` string, 
  `pid` double, 
  `send_area` string, 
  `sign` string, 
  `user_area` string, 
  `white_cnt` bigint, 
  `login_type` string, 
  `scca_number` string, 
  `identity_number` string)
comment 'SYS_USER'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/SYS_USER";