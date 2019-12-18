SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT 
	S_ESEAL.id,
	MD5(regexp_replace(t1.QZ_ZS_ID,' ','')) AS cert_id_fk,
	S_ESEAL_CS.CS_ID AS cs_id_fk,
	FROM_UNIXTIME(UNIX_TIMESTAMP(S_ESEAL.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
	S_ESEAL.qz_ym_id,
	S_ESEAL.qz_lx_id,
	S_ESEAL.qz_id,
	S_ESEAL.qz_nx,
	S_ESEAL.qz_yxq_ks,
	S_ESEAL.qz_yxq_js,
	S_ESEAL.qz_tp_kd,
	S_ESEAL.qz_tp_gd,
	S_ESEAL.create_user,
	S_ESEAL.modify_date,
	S_ESEAL.modify_user,
	S_ESEAL.qz_bz,
	CASE S_ESEAL.qz_zt	WHEN 0 THEN '启用'
				WHEN 1 THEN '不可'
				WHEN 2 THEN '注销'
				WHEN 3 THEN '变更'
				WHEN 4 THEN '续期'
				ELSE '其他'
				END AS qz_zt,
	S_ESEAL.qz_pid,
	S_ESEAL.qz_mc,
	S_ESEAL.qz_sqr,
	S_ESEAL.qz_sqr_dx,
	CASE S_ESEAL.IS_DEL WHEN 1 THEN '删除' WHEN 0 THEN '正常' ELSE '其他' END AS s_eseal_is_del,
	S_ESEAL.qz_sh_yj,
	CASE S_ESEAL.qz_sh_zt	WHEN 0 THEN '未审核'
				WHEN 1 THEN '审核未通过'
				WHEN 2 THEN '审核通过'
				WHEN 3 THEN '待审核'
				ELSE '其他'
				END AS qz_sh_zt,
	CASE S_ESEAL.qz_lx WHEN 0 THEN '模板' WHEN 1 THEN '图片' ELSE '其他' END AS qz_lx,
	S_ESEAL.qz_ly,
	S_ESEAL.qz_yw_zt,
	S_ESEAL.qz_tp_type,
	S_ESEAL.qz_zs_sn
FROM
    (select *  from ${hiveconf:odsDB}.S_ESEAL where ymd="${hiveconf:ymd}") AS S_ESEAL

LEFT JOIN

	(SELECT
		t2.QZ_ID,
		t2.QZ_ZS_ID
	FROM
		(SELECT
			ROW_NUMBER() OVER(PARTITION BY S_ESEAL_CERT_EC.QZ_ID ORDER BY S_ESEAL_CERT.QZ_ZS_ID)ID,
			S_ESEAL_CERT_EC.QZ_ID,
			S_ESEAL_CERT.QZ_ZS_ID
		FROM
			${hiveconf:odsDB}.S_ESEAL_CERT_EC AS S_ESEAL_CERT_EC
		JOIN
			${hiveconf:odsDB}.S_ESEAL_CERT AS S_ESEAL_CERT
		ON
			S_ESEAL_CERT_EC.ZS_ID = S_ESEAL_CERT.ID)t2
	WHERE 
		t2.ID = 1) t1
ON
	S_ESEAL.ID = t1.QZ_ID
LEFT JOIN 
	${hiveconf:odsDB}.S_ESEAL_CS AS S_ESEAL_CS
ON
	S_ESEAL.ID = S_ESEAL_CS.QZ_ID;
