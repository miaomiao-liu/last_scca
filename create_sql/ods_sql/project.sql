use ${hiveconf:ods_db};
create external table project(
  `id` int, 
  `proj_name` string, 
  `proj_manager` string, 
  `proj_auth_incharge` string, 
  `proj_init_date` string, 
  `current_number_to` int, 
  `init_date` string, 
  `id_char_1` string, 
  `id_char_2` string, 
  `projconninfo` string, 
  `projdescript` string, 
  `projnotice` string, 
  `identplan` string, 
  `deploydetail` string, 
  `plantformforcertuse` string, 
  `deliverynote` string, 
  `version` int, 
  `logid` bigint, 
  `modifytime` string, 
  `modifyperson` string, 
  `usernumberto` int, 
  `projshortname` string, 
  `addcertsnbyhand` string, 
  `showprojtreenode` string, 
  `projgroup_1` string, 
  `usescope_project` string, 
  `moveprojid_project` int, 
  `moveprojname_project` string, 
  `cooperid_ref` int)
comment 'project'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/project";