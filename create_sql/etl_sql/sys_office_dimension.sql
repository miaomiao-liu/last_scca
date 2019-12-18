use ${hiveconf:etl_db};
create external table sys_office_dimension(
  `id` double, 
  `parent_id` double, 
  `parent_ids` string, 
  `area_id` double, 
  `code` string, 
  `sys_office_name` string, 
  `sys_office_type` string, 
  `grade` string, 
  `sys_office_address` string, 
  `zip_code` string, 
  `master` string, 
  `sys_office_phone` string, 
  `fax` string, 
  `sys_office_email` string, 
  `create_by` double, 
  `create_date` string, 
  `update_by` double, 
  `update_date` string, 
  `remarks` string, 
  `del_flag` string, 
  `onfous` int, 
  `area_name` string)
comment 'sys_office_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/sys_office_dimension";