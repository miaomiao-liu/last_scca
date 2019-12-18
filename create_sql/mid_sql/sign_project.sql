use ${hiveconf:cboard_db};
create external table sign_project(
  `project_name` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 'sign_project'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/sign_project";
