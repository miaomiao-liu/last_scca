use ${hiveconf:ods_db};
create external table WORK_COMPANY_HIS(
  `id` double, 
  `actual_capital` string, 
  `address` string, 
  `age_dis_number` string, 
  `annual_inspection` string, 
  `business_number` string, 
  `city` string, 
  `com_certficate_number` string, 
  `com_certficate_time` string, 
  `com_certificate_type` string, 
  `com_english_name` string, 
  `com_phone` string, 
  `company_ip` string, 
  `company_mobile` string, 
  `company_name` string, 
  `company_type` string, 
  `company_web` string, 
  `district` string, 
  `enterprise_type` string, 
  `industry` string, 
  `legal_name` string, 
  `marketing_scope` string, 
  `org_expiration_time` string, 
  `organization_number` string, 
  `province` string, 
  `registered_capital` string, 
  `remarks` string, 
  `select_lv` string, 
  `tcp_number` string, 
  `zip_code` string, 
  `area_remark` string, 
  `two_level_company_name` string)
comment 'WORK_COMPANY_HIS'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/WORK_COMPANY_HIS";