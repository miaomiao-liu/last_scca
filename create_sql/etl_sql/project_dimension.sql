use ${hiveconf:etl_db};
create external table project_dimension(
  `id` string, 
  `project_name` string, 
  `pta_id` string, 
  `proj_text` string, 
  `proj_status` string, 
  `proj_manager` string, 
  `proj_auth_incharge` string, 
  `proj_init_date` string, 
  `current_number_to` int, 
  `project_ip` string, 
  `appid` string, 
  `project_del_flag` string, 
  `project_update_date` string, 
  `project_create_by` double, 
  `project_update_by` double, 
  `support_common` int, 
  `alias` string, 
  `config_product_type` double, 
  `pay_method` string, 
  `post_method` string, 
  `project_create_time` string)
comment 'project_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/project_dimension";