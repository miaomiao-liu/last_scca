use ${hiveconf:etl_db};
create external table sys_user_dimension(
  `id` string, 
  `sys_user_company_id` double, 
  `office_id` double, 
  `login_name` string, 
  `sys_user_password` string, 
  `sys_user_no` string, 
  `sys_user_name` string, 
  `sys_user_email` string, 
  `sys_user_phone` string, 
  `sys_user_mobile` string, 
  `user_type` string, 
  `login_ip` string, 
  `login_date` string, 
  `login_type` string, 
  `scca_number` string, 
  `identity_number` string)
comment 'sys_user_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/sys_user_dimension";
