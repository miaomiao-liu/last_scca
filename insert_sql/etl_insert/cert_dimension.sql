SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT 
 	MD5(regexp_replace(t1.cert_serialnumber,' ','')) id,
	t1.cert_serialnumber,
	t1.issuer_dn,
	t1.issuer_hash_md5,
	t1.cert_notafter,
	t1.notbefore,
	t1.obtained,
	t1.provider,
	t1.req_buf_type,
	t1.req_challenge,
	t1.revoke_date,
	t1.sign_date,
	t1.subject_dn,
	t1.subject_hash_md5,
	t1.trust_device_count,
	t1.trust_device_date,
	t1.apply_info,
	t1.key_sn,
	t1.work_user_id,
	t1.cert_kmc_rep1,
	t1.cert_kmc_rep2,
	t1.cert_kmc_rep3,
	t1.cert_serialnumber_kmc,
	t1.cert_sign_buf_kmc,
	t1.cert_create_date,
	t1.zs_cn,
	t1.zs_dn,
	t1.zs_base64,
	t1.cert_is_del,
	t1.cert_proj_id,
	t2.certification_type AS cert_type
FROM
	(SELECT
		(CASE	WHEN lower(WORK_CERT_INFO.SERIALNUMBER) NOT in ('', 'null') 
				THEN WORK_CERT_INFO.SERIALNUMBER
				WHEN lower(S_ESEAL_CERT.QZ_ZS_ID)  NOT in ('', 'null') 
				THEN S_ESEAL_CERT.QZ_ZS_ID
				END) AS cert_serialnumber,
		WORK_CERT_INFO.issuer_dn,
		WORK_CERT_INFO.issuer_hash_md5,
		WORK_CERT_INFO.notafter AS cert_notafter,
		WORK_CERT_INFO.notbefore,
		WORK_CERT_INFO.obtained,
		WORK_CERT_INFO.provider,
		WORK_CERT_INFO.req_buf_type,
		WORK_CERT_INFO.req_challenge,
		WORK_CERT_INFO.revoke_date,
		WORK_CERT_INFO.sign_date,
		WORK_CERT_INFO.subject_dn,
		WORK_CERT_INFO.subject_hash_md5,
		WORK_CERT_INFO.trust_device_count,
		WORK_CERT_INFO.trust_device_date,
		WORK_CERT_INFO.apply_info,
		WORK_CERT_INFO.key_sn,
		WORK_CERT_INFO.work_user_id,
		WORK_CERT_INFO.cert_kmc_rep1,
		WORK_CERT_INFO.cert_kmc_rep2,
		WORK_CERT_INFO.cert_kmc_rep3,
		WORK_CERT_INFO.cert_serialnumber_kmc,
		WORK_CERT_INFO.cert_sign_buf_kmc,
		WORK_CERT_INFO.create_date AS cert_create_date,
		S_ESEAL_CERT.zs_cn,
		S_ESEAL_CERT.zs_dn,
		S_ESEAL_CERT.zs_base64,
		(CASE S_ESEAL_CERT.is_del WHEN 0 THEN '正常' WHEN 1 THEN '删除' ELSE '其他' END) AS cert_is_del,
		S_ESEAL_CERT.proj_id AS cert_proj_id
	FROM
		(SELECT * FROM
			(SELECT
				SERIALNUMBER,
				ROW_NUMBER() OVER (PARTITION BY SERIALNUMBER ORDER BY ID) NUM,
				issuer_dn,
				issuer_hash_md5,
				notafter,
				notbefore,
				obtained,
				provider,
				req_buf_type,
				req_challenge,
				revoke_date,
				sign_date,
				subject_dn,
				subject_hash_md5,
				trust_device_count,
				trust_device_date,
				apply_info,
				key_sn,
				work_user_id,
				cert_kmc_rep1,
				cert_kmc_rep2,
				cert_kmc_rep3,
				cert_serialnumber_kmc,
				cert_sign_buf_kmc, 
				create_date
			FROM
				${hiveconf:odsDB}.WORK_CERT_INFO ) t11
		WHERE NUM = 1) AS WORK_CERT_INFO

	FULL JOIN

		(SELECT * FROM
			(SELECT
				QZ_ZS_ID,
				ROW_NUMBER() OVER (PARTITION BY QZ_ZS_ID ORDER BY ID) NUM,
				zs_cn,
				zs_dn,
				zs_base64,
				is_del,
				proj_id
			FROM
				${hiveconf:odsDB}.S_ESEAL_CERT) t22 
		WHERE NUM = 1 ) AS S_ESEAL_CERT
	ON
		WORK_CERT_INFO.SERIALNUMBER = S_ESEAL_CERT.QZ_ZS_ID) t1

LEFT JOIN

	(SELECT
			key_table.cert_serialNamber,
			customer_info.certification_type
		FROM
			${hiveconf:odsDB}.key_table AS key_table
		JOIN
			${hiveconf:odsDB}.customer_info AS customer_info
		ON
			key_table.customer_id = customer_info.customer_id)t2
ON
	regexp_replace(t1.cert_serialnumber,' ','') = regexp_replace(t2.cert_serialNamber,' ','')
WHERE lower(cert_serialnumber) NOT IN ('null','');
