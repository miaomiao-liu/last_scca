SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	CONCAT(ID,'A') AS id,
	company_name,
	com_english_name,
	(CASE company_type
		WHEN -1 THEN '迁移'
		WHEN 1 THEN '企业'
		WHEN 2 THEN '事业单位'
		WHEN 3 THEN '未知'
		WHEN 4 THEN '社会团体'
		WHEN 5 THEN '其他'
		WHEN 6 THEN '个体工商户'
		ELSE '其他'
		END) AS company_type,
	(CASE com_certificate_type 
		WHEN 0 THEN '企业'
		WHEN 1 THEN '法人'
		WHEN 2 THEN '团体' 
		ELSE '其他'
		END) AS com_certificate_type,
	com_certficate_number,
	business_number,
	organization_number,
	org_expiration_time,
	com_phone,
	zip_code,
	legal_name,
	province,
	city,
	district,
	address AS company_address,
	company_mobile,
	industry,
	registered_capital,
	actual_capital,
	company_ip,
	company_web,
	com_certficate_time,
	area_remark
from ${hiveconf:odsDB}.WORK_COMPANY

UNION ALL

SELECT
	CONCAT(ID,'B') AS id,
	company_name,
	com_english_name,
	(CASE company_type	
		WHEN -1 THEN '迁移'
		WHEN 1 THEN '企业'
		WHEN 2 THEN '事业单位'
		WHEN 3 THEN '未知'
		WHEN 4 THEN '社会团体'
		WHEN 5 THEN '其他'
		WHEN 6 THEN '个体工商户'
		ELSE '其他'
		END) AS company_type,
	(CASE com_certificate_type
		WHEN 0 THEN '企业'
		WHEN 1 THEN '法人'
		WHEN 2 THEN '团体'
		ELSE '其他'
		END) AS com_certificate_type,
	com_certficate_number,
	business_number,
	organization_number,
	org_expiration_time,
	com_phone,
	zip_code,
	legal_name,
	province,
	city,
	district,
	address AS company_address,
	company_mobile,
	industry,
	registered_capital,
	actual_capital,
	company_ip,
	company_web,
	com_certficate_time,
	area_remark
from ${hiveconf:odsDB}.WORK_COMPANY_HIS;