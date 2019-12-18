use ${hiveconf:etl_db};
create external table company_dimension(
  `id` string, 
  `company_name` string, 
  `com_english_name` string, 
  `company_type` string, 
  `com_certificate_type` string, 
  `com_certficate_number` string, 
  `business_number` string, 
  `organization_number` string, 
  `org_expiration_time` string, 
  `com_phone` string, 
  `zip_code` string, 
  `legal_name` string, 
  `province` string, 
  `city` string, 
  `district` string, 
  `company_address` string, 
  `company_mobile` string, 
  `industry` string, 
  `registered_capital` string, 
  `actual_capital` string, 
  `company_ip` string, 
  `company_web` string, 
  `com_certficate_time` string, 
  `area_remark` string)
comment 'company_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/company_dimension";