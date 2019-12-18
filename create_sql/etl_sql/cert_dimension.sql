use ${hiveconf:etl_db};
create external table cert_dimension(
  `id` string, 
  `cert_serialnumber` string, 
  `issuer_dn` string, 
  `issuer_hash_md5` string, 
  `cert_notafter` string, 
  `notbefore` string, 
  `obtained` int, 
  `provider` string, 
  `req_buf_type` string, 
  `req_challenge` string, 
  `revoke_date` string, 
  `sign_date` string, 
  `subject_dn` string, 
  `subject_hash_md5` string, 
  `trust_device_count` bigint, 
  `trust_device_date` string, 
  `apply_info` double, 
  `key_sn` string, 
  `work_user_id` double, 
  `cert_kmc_rep1` string, 
  `cert_kmc_rep2` string, 
  `cert_kmc_rep3` string, 
  `cert_serialnumber_kmc` string, 
  `cert_sign_buf_kmc` string, 
  `cert_create_date` string, 
  `zs_cn` string, 
  `zs_dn` string, 
  `zs_base64` string, 
  `cert_is_del` string, 
  `cert_proj_id` string, 
  `cert_type` string)
comment 'cert_dimension'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/cert_dimension";