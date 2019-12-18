use ${hiveconf:ods_db};
create external table S_ESEAL_CS(
  `id` double, 
  `qz_id` string, 
  `cs_id` double)
comment 'S_ESEAL_CS'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_ESEAL_CS";