use ${hiveconf:etl_db};
create external table s_d_qzcs_dimension(
  `id` double, 
  `qz_cs_mc` string, 
  `qz_cs_bz` string, 
  `qz_cs_dm` string)
  comment 's_d_qzcs_dimension'
  PARTITIONED BY (ymd string)
  ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\001'
  LINES TERMINATED BY '\n'
  STORED AS TEXTFILE
  LOCATION "${hiveconf:etl_hdfs}/etl_db/s_d_qzcs_dimension";
