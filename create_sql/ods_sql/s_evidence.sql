use ${hiveconf:ods_db};
create external table S_EVIDENCE(
  `id` string, 
  `appid` string, 
  `proj_id` string, 
  `req_id` string, 
  `version` string, 
  `type` string, 
  `businesstype` string, 
  `clientip` string, 
  `create_time` string, 
  `cert_serialnumber` string, 
  `ori_data` string, 
  `signed_data` string, 
  `srcuploadfiles` string, 
  `enterprise_name` string, 
  `org_code` string, 
  `time_data` string)
comment 'S_EVIDENCE'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_EVIDENCE";