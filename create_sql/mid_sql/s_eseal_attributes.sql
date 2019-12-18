use ${hiveconf:cboard_db};
create external table s_eseal_attributes(
  `qz_nx` double, 
  `qz_zt` string, 
  `qz_sh_zt` string, 
  `year` string, 
  `season` string, 
  `month` string, 
  `number` bigint)
comment 's_eseal_attributes'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:cboard_hdfs}/cboard_db/s_eseal_attributes";
