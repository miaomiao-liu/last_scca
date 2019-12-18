SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	CONCAT(ID,'B') AS id,
	address AS user_address,
	con_cert_number,
	(CASE con_cert_type WHEN 0 THEN '身份证' WHEN 1 THEN '军官证' ELSE '其他' END) AS con_cert_type,
	contact_email,
	contact_name,
	contact_phone,
	contact_sex,
	contact_tel,
	department,
	source,
	company_his_id AS user_company_id,
	(CASE status WHEN 0 THEN '联系人' WHEN 1 THEN '经办人' ELSE '其他' END) AS user_status,
	null as contact_name_old
FROM ${hiveconf:odsDB}.WORK_USER_HIS
union all
SELECT
	CONCAT(ID,'A') AS id,
	address AS user_address,
	con_cert_number,
	(CASE con_cert_type WHEN 0 THEN '身份证' WHEN 1 THEN '军官证' ELSE '其他' END) AS con_cert_type,
	contact_email,
	contact_name,
	contact_phone,
	contact_sex,
	contact_tel,
	department,
	source,
	company_id AS user_company_id,
	(CASE status WHEN 0 THEN '联系人' WHEN 1 THEN '经办人' ELSE '其他' END) AS user_status,
	contact_name_old
FROM ${hiveconf:odsDB}.WORK_USER;

