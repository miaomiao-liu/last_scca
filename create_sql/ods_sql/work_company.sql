use ${hiveconf:ods_db};
create external table WORK_COMPANY(
  `id` double, 
  `company_name` string, 
  `com_english_name` string, 
  `company_type` string, 
  `com_certificate_type` string, 
  `com_certficate_number` string, 
  `business_number` string, 
  `select_lv` string, 
  `organization_number` string, 
  `org_expiration_time` string, 
  `com_phone` string, 
  `zip_code` string, 
  `tcp_number` string, 
  `age_dis_number` string, 
  `legal_name` string, 
  `province` string, 
  `city` string, 
  `district` string, 
  `address` string, 
  `company_mobile` string, 
  `enterprise_type` string, 
  `marketing_scope` string, 
  `annual_inspection` string, 
  `industry` string, 
  `registered_capital` string, 
  `actual_capital` string, 
  `company_ip` string, 
  `company_web` string, 
  `remarks` string, 
  `com_certficate_time` string, 
  `area_remark` string, 
  `two_level_company_name` string)
comment 'WORK_COMPANY'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/WORK_COMPANY";