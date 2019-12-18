use ${hiveconf:cboard_db};
create external table evidence_cert(
  `cert_type` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 'evidence_cert'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/evidence_cert";
