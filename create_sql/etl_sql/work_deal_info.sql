use ${hiveconf:etl_db};
create external table work_deal_info(
  `id` string, 
  `office_id_fk` double, 
  `company_id_fk` string, 
  `deal_info_type` string, 
  `time_id_fk` string, 
  `company_his_id_fk` string, 
  `attestation_user` string, 
  `business_card_user` string, 
  `input_user` string, 
  `cert_id_fk` string, 
  `project_id_fk` string, 
  `user_id_fk` string, 
  `user_his_id_fk` string, 
  `deal_info_status` string, 
  `deal_info_type1` string, 
  `deal_info_type2` string, 
  `deal_info_type3` string, 
  `prev_id` double, 
  `attestation_user_date` string, 
  `deal_notafter` string, 
  `revoke_date` string, 
  `is_revoke_business` string)
comment 'work_deal_info'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/work_deal_info";