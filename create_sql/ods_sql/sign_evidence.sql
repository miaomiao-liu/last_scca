use ${hiveconf:ods_db};
create external table sign_evidence(
  `id` string, 
  `proj_id` string, 
  `req_id` string, 
  `req_version` string, 
  `create_time` string, 
  `businesstype` string, 
  `ip` string, 
  `cert_serialnumber` string, 
  `ori_data` string, 
  `signed_data` string, 
  `enterprise_name` string, 
  `time_data` string)
comment 'sign_evidence'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/sign_evidence";