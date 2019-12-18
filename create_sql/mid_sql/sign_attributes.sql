use ${hiveconf:cboard_db};
create external table sign_attributes(
  `businesstype` string, 
  `sign_enterprise_name` string, 
  `year` string, 
  `month` string, 
  `season` string, 
  `hour` string, 
  `number` bigint)
comment 'sign_attributes'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/sign_attributes"; 
