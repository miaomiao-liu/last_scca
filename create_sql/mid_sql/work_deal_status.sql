use ${hiveconf:cboard_db};
create external table work_deal_status(
`deal_info_status` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 'work_deal_status'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/work_deal_status";
