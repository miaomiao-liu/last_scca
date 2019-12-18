SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	CONCAT(CertUpdate.ID,'B') AS ID,
    NULL AS office_id_fk,
    CONCAT(t5.COMPANY_ID,'A') AS company_id_fk,
    '更新' AS deal_info_type,
    FROM_UNIXTIME(UNIX_TIMESTAMP(CertUpdate.AddInTime),'yyyy-MM-dd HH:mm') AS time_id_fk,
    NULL AS company_his_id_fk,
	(CASE	WHEN t3.NO IS NOT NULL THEN  MD5(regexp_replace(CONCAT(CertUpdate.IdentPerson,t3.NO),"\\s{1,}|\t",''))
			ELSE MD5(regexp_replace(CertUpdate.IdentPerson,"\\s{1,}|\t",''))
			END) AS attestation_user,
    NULL AS business_card_user,
    NULL AS input_user,
    MD5(regexp_replace(CertUpdate.CertSN,"\\s{1,}|\t",'')) AS cert_id_fk,
    MD5(regexp_replace(CertUpdate.ProjName,"\\s{1,}|\t",'')) AS project_id_fk,
    CONCAT(t5.ID,'A') AS user_id_fk,
    NULL AS user_his_id_fk,
    NULL AS deal_info_status,
    NULL AS deal_info_type1,
    NULL AS deal_info_type2,
    NULL AS deal_info_type3,
    NULL AS prev_id,
    CertUpdate.IdentTime AS attestation_user_date,
    CertUpdate.CERT_NOTAFTER AS deal_notafter,
    CertUpdate.CertUpdate_deleteDate AS revoke_date,
    CASE CertUpdate.CertUpdate_deleteTag WHEN '是' THEN '吊销业务' ELSE '非吊销业务' END AS is_revoke_business
FROM
(select * from ${hiveconf:odsDB}.CertUpdate where ymd="${hiveconf:ymd}") AS CertUpdate

LEFT JOIN
	(SELECT * FROM
		(SELECT 
			ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ID) NUM,
			COMPANY_ID,
			office_id,
			login_name,
			PASSWORD,
			NO,
			NAME,
			EMAIL,
			PHONE,
			MOBILE,
			user_type,
			login_ip,
			login_date,
			login_type,
			scca_number,
			identity_number
		FROM ${hiveconf:odsDB}.SYS_USER AS SYS_USER) t2 
	WHERE t2.NUM = 1) t3
ON
        CertUpdate.IdentPerson = t3.NAME
LEFT JOIN
	(SELECT * FROM
		(SELECT
			ID,
			address,
			con_cert_number,
			(CASE con_cert_type WHEN 0 THEN '身份证' WHEN 1 THEN '军官证' ELSE '其他' END) AS con_cert_type,
			contact_email,
			ROW_NUMBER() OVER (PARTITION BY contact_name ORDER BY id) NUM,
			contact_name,
			contact_phone,
			contact_sex,
			contact_tel,
			department,
			source,
			company_id,
			(CASE status WHEN 0 THEN '联系人' WHEN 1 THEN '经办人' ELSE '其他' END) AS status,
			contact_name_old
		FROM
			${hiveconf:odsDB}.WORK_USER) t4
		WHERE t4.NUM = 1) t5
ON
        CertUpdate.CertCN = t5.CONTACT_NAME
UNION ALL
SELECT
	CONCAT(WORK_DEAL_INFO.ID,'A') AS ID,
	WORK_DEAL_INFO.OFFICE_ID AS office_id_fk,
	CONCAT(WORK_DEAL_INFO.WORK_COMPANY_ID ,'A') AS company_id_fk,
	CASE WORK_DEAL_INFO.deal_info_type WHEN 0 THEN '新增' WHEN 1 THEN '更新' WHEN 11 THEN '业务更新' ELSE '其他' END AS deal_info_type,
	FROM_UNIXTIME(UNIX_TIMESTAMP(WORK_DEAL_INFO.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
	CONCAT(WORK_DEAL_INFO.WORK_COMPANY_HIS_ID ,'B') AS company_his_id_fk,
	MD5(regexp_replace(CONCAT(sys_user1.no,sys_user1.name),"\\s{1,}|\t",'')) AS attestation_user,
	MD5(regexp_replace(CONCAT(sys_user2.no,sys_user2.name),"\\s{1,}|\t",'')) AS business_card_user,
	MD5(regexp_replace(CONCAT(sys_user3.no,sys_user3.name),"\\s{1,}|\t",'')) AS input_user,
	MD5(regexp_replace(WORK_DEAL_INFO.CERT_SN,"\\s{1,}|\t",'')) AS cert_id_fk,
	MD5(regexp_replace(CONFIG_APP.APP_NAME,"\\s{1,}|\t",'')) AS project_id_fk,
	CONCAT(WORK_DEAL_INFO.WORK_USER_ID,'A') AS user_id_fk,
	CONCAT(WORK_DEAL_INFO.WORK_USER_HIS_ID,'B') AS user_his_id_fk,
	CASE WORK_DEAL_INFO.deal_info_status 
		WHEN 0 THEN '新增用户' 
		WHEN 1 THEN '异常业务' 
		WHEN 2 THEN '退费用户' 
		WHEN 4 THEN '审核不通过' 
		WHEN 5 THEN '录入成功' 
		WHEN 6 THEN '吊销'
		WHEN 7 THEN '已获取'
		WHEN 8 THEN '临时保存' 
		WHEN 9 THEN '等待制证' 
		WHEN 10 THEN '已失效' 
		WHEN 11 THEN '待获取' 
		WHEN 12 THEN '未缴费，待审核' 
		WHEN 13 THEN '已审核，待制证' 
		WHEN 16 THEN '已鉴别，待验证'
		WHEN 17 THEN '鉴别拒绝'
	    ELSE '其他' END AS deal_info_status,
	CASE WORK_DEAL_INFO.deal_info_type1 WHEN 2 THEN '遗失补办' WHEN 3 THEN '损坏更新' ELSE '其他' END AS deal_info_type1,
	CASE WORK_DEAL_INFO.deal_info_type2 WHEN 4 THEN '变更' ELSE '其他' END AS deal_info_type2,
	CASE WORK_DEAL_INFO.deal_info_type3 WHEN 12 THEN '变更缴费' ELSE '其他' END AS deal_info_type3,
	WORK_DEAL_INFO.prev_id,
	WORK_DEAL_INFO.attestation_user_date,
	WORK_DEAL_INFO.notafter AS deal_notafter,
	WORK_DEAL_INFO.revoke_date,
	CASE WORK_DEAL_INFO.is_revoke_business WHEN 1 THEN '吊销业务' ELSE '非吊销业务' END AS is_revoke_business
FROM 
(select * from ${hiveconf:odsDB}.WORK_DEAL_INFO where ymd="${hiveconf:ymd}") AS WORK_DEAL_INFO

LEFT JOIN
        ${hiveconf:odsDB}.SYS_USER AS sys_user1
ON
        WORK_DEAL_INFO.ATTESTATION_USER = sys_user1.ID
LEFT JOIN

        ${hiveconf:odsDB}.SYS_USER AS sys_user2
ON
        WORK_DEAL_INFO.BUSINESS_CARD_USER = sys_user2.ID
LEFT JOIN
        ${hiveconf:odsDB}.SYS_USER AS sys_user3
ON
        WORK_DEAL_INFO.INPUT_USER = sys_user3.ID
LEFT JOIN
        ${hiveconf:odsDB}.CONFIG_APP
ON
        WORK_DEAL_INFO.APP_ID = CONFIG_APP.ID;