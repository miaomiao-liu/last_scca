use ${hiveconf:etl_db};
create external table user_dimension(
  `id` string, 
  `user_address` string, 
  `con_cert_number` string, 
  `con_cert_type` string, 
  `contact_email` string, 
  `contact_name` string, 
  `contact_phone` string, 
  `contact_sex` string, 
  `contact_tel` string, 
  `department` string, 
  `source` bigint, 
  `user_company_id` double, 
  `user_status` string, 
  `contact_name_old` string)
comment 'user_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/user_dimension";