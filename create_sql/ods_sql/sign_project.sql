use ${hiveconf:ods_db};
create external table sign_project(
  `id` string, 
  `proj_id` string, 
  `proj_name` string, 
  `create_time` string, 
  `proj_status` string, 
  `pta_id` string, 
  `proj_text` string, 
  `cert_id` string)
comment 'sign_project'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/sign_project";