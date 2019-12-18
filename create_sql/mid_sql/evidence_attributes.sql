use ${hiveconf:cboard_db};
create external table evidence_attributes(
  `evidence_enterprise_name` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 'evidence_attributes'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/evidence_attributes";
