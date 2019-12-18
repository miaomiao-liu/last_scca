use ${hiveconf:etl_db};
create external table cert_use_info(
  `i_xin_id_fk` double, 
  `time_id_fk` string, 
  `cert_id_fk` string, 
  `project_id_fk` string, 
  `customer_id_fk` int, 
  `access_type` string, 
  `del_flag` string, 
  `access_time` string)
comment 'cert_use_info'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/cert_use_info";