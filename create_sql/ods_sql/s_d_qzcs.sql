use ${hiveconf:ods_db};
create external table S_D_QZCS(
  `id` double, 
  `qz_cs_mc` string, 
  `qz_cs_bz` string, 
  `create_user` string, 
  `create_date` string, 
  `modify_user` string, 
  `modify_date` string, 
  `qz_cs_dm` string)
comment 'S_D_QZCS'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_D_QZCS";