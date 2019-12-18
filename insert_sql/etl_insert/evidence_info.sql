SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
    S_EVIDENCE.id,
    S_EVIDENCE.APPID AS client_id_fk,
    MD5(regexp_replace(S_PROJECTCONFIG.PROJECTNAME,' ','')) AS project_id_fk,
    MD5(regexp_replace(S_EVIDENCE.CERT_SERIALNUMBER,' ','')) AS cert_id_fk,
    FROM_UNIXTIME(UNIX_TIMESTAMP(S_EVIDENCE.CREATE_TIME),'yyyy-MM-dd HH:mm') AS time_id_fk,
    S_EVIDENCE.req_id,
    S_EVIDENCE.version AS jar_version,
    CASE S_EVIDENCE.type WHEN 1 THEN '文本' WHEN 0 THEN '文件' END AS evidence_type,
    S_EVIDENCE.clientip AS client_ip,
    S_EVIDENCE.businesstype AS business_type,
    S_EVIDENCE.ori_data,
    S_EVIDENCE.SRCUPLOADFILES AS srcup_load_files,
    S_EVIDENCE.time_data,
    S_EVIDENCE.ENTERPRISE_NAME AS evidence_enterprise_name,
    S_EVIDENCE.ORG_CODE AS evidence_org_code
FROM
	(select * from ${hiveconf:odsDB}.S_EVIDENCE where ymd="${hiveconf:ymd}" ) AS S_EVIDENCE 

LEFT JOIN
	${hiveconf:odsDB}.S_PROJECTCONFIG AS S_PROJECTCONFIG
ON
	S_EVIDENCE.PROJ_ID = S_PROJECTCONFIG.PROJ_ID
LEFT JOIN
	${hiveconf:odsDB}.S_CLIENT AS S_CLIENT
ON
	S_EVIDENCE.APPID = S_CLIENT.APPID;
 