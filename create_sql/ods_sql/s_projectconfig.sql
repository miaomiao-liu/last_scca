use ${hiveconf:ods_db};
create external table S_PROJECTCONFIG(
  `proj_id` string, 
  `projectname` string, 
  `project_ip` string, 
  `id` double, 
  `appid` string)
comment 'S_PROJECTCONFIG'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_PROJECTCONFIG";