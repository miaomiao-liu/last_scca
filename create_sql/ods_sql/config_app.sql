use ${hiveconf:ods_db};
create external table CONFIG_APP(
  `id` double, 
  `app_name` string, 
  `app_label` bigint, 
  `app_description` string, 
  `app_img` string, 
  `create_date` string, 
  `del_flag` string, 
  `remarks` string, 
  `update_date` string, 
  `create_by` double, 
  `update_by` double, 
  `app_type` bigint, 
  `support_common` int, 
  `gov_device_amount` double, 
  `alias` string, 
  `config_product_type` double, 
  `apply_flag1` int, 
  `apply_flag2` int, 
  `pay_method` int, 
  `post_method` int)
comment 'CONFIG_APP'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/CONFIG_APP";