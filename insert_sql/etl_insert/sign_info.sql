SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT 
	sign_evidence.id,
	MD5(regexp_replace(sign_evidence.cert_serialnumber,' ','')) AS cert_id_fk,
	FROM_UNIXTIME(UNIX_TIMESTAMP(sign_evidence.create_time),'yyyy-MM-dd HH:mm') AS time_id_fk,
	MD5(regexp_replace(sign_project.proj_name,' ','')) AS project_id_fk,
	sign_evidence.ori_data,
	sign_evidence.enterprise_name AS sign_enterprise_name,
	sign_evidence.businesstype,
	sign_evidence.req_version,
	sign_evidence.ip
FROM
(select * from ${hiveconf:odsDB}.sign_evidence where ymd="${hiveconf:ymd}") AS sign_evidence 
LEFT JOIN
${hiveconf:odsDB}.sign_project AS sign_project
ON
sign_evidence.proj_id = sign_project.proj_id;