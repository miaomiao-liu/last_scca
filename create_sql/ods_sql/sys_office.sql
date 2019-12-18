use ${hiveconf:ods_db};
create external table SYS_OFFICE(
  `id` double, 
  `parent_id` double, 
  `parent_ids` string, 
  `area_id` double, 
  `code` string, 
  `name` string, 
  `type` string, 
  `grade` string, 
  `address` string, 
  `zip_code` string, 
  `master` string, 
  `phone` string, 
  `fax` string, 
  `email` string, 
  `create_by` double, 
  `create_date` string, 
  `update_by` double, 
  `update_date` string, 
  `remarks` string, 
  `del_flag` string, 
  `onfous` int, 
  `area_name` string)
comment 'SYS_OFFICE'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/SYS_OFFICE";