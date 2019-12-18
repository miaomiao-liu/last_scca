use ${hiveconf:ods_db};
create external table S_ESEAL(
  `id` double, 
  `qz_ym_id` double, 
  `qz_lx_id` double, 
  `qz_id` string, 
  `qz_nx` double, 
  `qz_yxq_ks` string, 
  `qz_yxq_js` string, 
  `qz_tp_kd` string, 
  `qz_tp_gd` string, 
  `create_date` string, 
  `create_user` string, 
  `modify_date` string, 
  `modify_user` string, 
  `qz_bz` string, 
  `qz_zt` double, 
  `qz_sh_zt` double, 
  `qz_pid` string, 
  `qz_mc` string, 
  `qz_sqr` string, 
  `qz_sqr_dx` string, 
  `is_del` double, 
  `qz_sh_yj` string, 
  `qz_lx` double, 
  `qz_ly` string, 
  `qz_yw_zt` double, 
  `qz_tp_gif` string, 
  `qz_tp_png` string, 
  `qz_tp_type` string, 
  `qz_zs_sn` string, 
  `qz_cs` string)
comment 'S_ESEAL'
PARTITIONED BY (ymd string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION "${hiveconf:ods_hdfs}/ods_db/S_ESEAL";