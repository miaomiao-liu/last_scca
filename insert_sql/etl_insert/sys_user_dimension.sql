SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")

SELECT
	MD5(regexp_replace(t2.identperson,' ','')) AS id,
	null AS sys_user_company_id,
	null AS office_id,
	null AS login_name,
	null AS sys_user_password,
	null AS sys_user_no,
	t2.identperson AS sys_user_name,
	null AS sys_user_email,
	null AS sys_user_phone,
	null AS sys_user_mobile,
	null AS user_type,
	null AS login_ip,
	null AS login_date,
	null AS login_type,
	null AS scca_number,
	null AS identity_number
FROM
	(SELECT
		DISTINCT t1.identperson
	FROM
		(SELECT
			CertUpdate.identperson,
			SYS_USER.name
		FROM
			${hiveconf:odsDB}.CertUpdate AS CertUpdate
		LEFT JOIN
			${hiveconf:odsDB}.SYS_USER AS SYS_USER
		ON
			trim(CertUpdate.identperson) = trim(SYS_USER.name)) t1
	WHERE lower(t1.identperson) NOT in ('null','') AND t1.name IS NULL) t2
union all
SELECT 
	MD5(regexp_replace(CONCAT(name,NO),' ','')) AS id,
	COMPANY_ID AS sys_user_company_id,
	office_id,
	login_name,
	PASSWORD AS sys_user_password,
	NO AS sys_user_no,
	NAME AS sys_user_name,
	EMAIL AS sys_user_email,
	PHONE AS sys_user_phone,
	MOBILE AS sys_user_mobile,
	user_type,
	login_ip,
	login_date,
	login_type,
	scca_number,
	identity_number
from ${hiveconf:odsDB}.SYS_USER;