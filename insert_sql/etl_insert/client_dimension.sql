SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
select
	APPID AS id,
	APPIP AS app_ip,
	(CASE APPSTATUS WHEN 0 THEN '正常' WHEN 1 THEN '停用' ELSE '其他' END) AS app_status,
	org_name,
	contractman,
	MOBILE AS client_mobile,
	EMAIL AS client_email,
	org_code,
	APPSECRET AS app_secret,
	CREATE_TIME AS client_create_time,
	CREATE_BY AS client_create_by,
	UPDATE_DATE AS client_update_date,
	UPDATE_BY AS client_update_by
	from ${hiveconf:odsDB}.S_CLIENT;
