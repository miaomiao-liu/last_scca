use ${hiveconf:etl_db};
create external table time_dimension(
  `id` string, 
  `year` string, 
  `month` string, 
  `day` string, 
  `hour` string, 
  `minute` string, 
  `date_time` string, 
  `season` string, 
  `time_stamp` string)
comment 'time_dimension'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "/scca/time_dimension";

