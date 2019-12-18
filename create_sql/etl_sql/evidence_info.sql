use ${hiveconf:etl_db};
create external table evidence_info(
  `id` string, 
  `client_id_fk` string, 
  `project_id_fk` string, 
  `cert_id_fk` string, 
  `time_id_fk` string, 
  `req_id` string, 
  `jar_version` string, 
  `evidence_type` string, 
  `client_ip` string, 
  `business_type` string, 
  `ori_data` string, 
  `srcup_load_files` string, 
  `time_data` string, 
  `evidence_enterprise_name` string, 
  `evidence_org_code` string)
comment 'evidence_info'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/evidence_info";