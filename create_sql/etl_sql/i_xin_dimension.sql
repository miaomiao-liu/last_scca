use ${hiveconf:etl_db};
create external table i_xin_dimension(
  `id` double, 
  `ie_version` string, 
  `cpu_id` string, 
  `ixin_version` string, 
  `ip` string, 
  `os_version` string)
comment 'i_xin_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/i_xin_dimension";