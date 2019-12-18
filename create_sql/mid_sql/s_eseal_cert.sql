use ${hiveconf:cboard_db};
create external table s_eseal_cert(
  `cert_type` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 's_eseal_cert'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/s_eseal_cert";
