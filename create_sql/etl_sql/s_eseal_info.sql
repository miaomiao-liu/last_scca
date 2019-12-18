use ${hiveconf:etl_db};
create external table s_eseal_info(
  `id` double, 
  `cert_id_fk` string, 
  `cs_id_fk` double, 
  `time_id_fk` string, 
  `qz_ym_id` double, 
  `qz_lx_id` double, 
  `qz_id` string, 
  `qz_nx` double, 
  `qz_yxq_ks` string, 
  `qz_yxq_js` string, 
  `qz_tp_kd` string, 
  `qz_tp_gd` string, 
  `create_user` string, 
  `modify_date` string, 
  `modify_user` string, 
  `qz_bz` string, 
  `qz_zt` string, 
  `qz_pid` string, 
  `qz_mc` string, 
  `qz_sqr` string, 
  `qz_sqr_dx` string, 
  `s_eseal_is_del` string, 
  `qz_sh_yj` string, 
  `qz_sh_zt` string, 
  `qz_lx` string, 
  `qz_ly` string, 
  `qz_yw_zt` double, 
  `qz_tp_type` string, 
  `qz_zs_sn` string)
comment 's_eseal_info'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:etl_hdfs}/etl_db/s_eseal_info";