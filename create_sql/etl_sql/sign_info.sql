use ${hiveconf:etl_db};
create external table sign_info(
  `id` string, 
  `cert_id_fk` string, 
  `time_id_fk` string, 
  `project_id_fk` string, 
  `ori_data` string, 
  `sign_enterprise_name` string, 
  `businesstype` string, 
  `req_version` string, 
  `ip` string)
comment 'sign_info'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/sign_info";