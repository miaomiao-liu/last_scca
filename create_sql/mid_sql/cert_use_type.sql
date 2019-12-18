use ${hiveconf:cboard_db};
create external table cert_use_type(
  `access_type` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 'cert_use_type'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/cert_use_type";
