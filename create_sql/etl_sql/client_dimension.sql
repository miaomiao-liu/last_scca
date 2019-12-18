use ${hiveconf:etl_db};
create external table client_dimension(
  `id` string, 
  `app_ip` string, 
  `app_status` string, 
  `org_name` string, 
  `contractman` string, 
  `client_mobile` string, 
  `client_email` string, 
  `org_code` string, 
  `app_secret` string, 
  `client_create_time` string, 
  `client_create_by` string, 
  `client_update_date` string, 
  `client_update_by` string)
  comment 'client_dimension'
  PARTITIONED BY (ymd string)
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\001'
  LINES TERMINATED BY '\n'
  STORED AS TEXTFILE
  LOCATION "${hiveconf:etl_hdfs}/etl_db/client_dimension";
