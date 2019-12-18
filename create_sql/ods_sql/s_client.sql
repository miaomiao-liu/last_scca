use ${hiveconf:ods_db};
create external table S_CLIENT(
  `id` double, 
  `appip` string, 
  `appstatus` int, 
  `org_name` string, 
  `contractman` string, 
  `mobile` string, 
  `email` string, 
  `org_code` string, 
  `appsecret` string, 
  `create_time` string, 
  `create_by` string, 
  `update_date` string, 
  `update_by` string, 
  `remark` string, 
  `appid` string)
comment 'S_CLIENT'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_CLIENT";