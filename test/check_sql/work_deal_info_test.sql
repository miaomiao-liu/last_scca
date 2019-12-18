SET hive.auto.convert.join=false;
SELECT 
    COUNT(*)
FROM
    (SELECT
        COUNT(*) AS NUM
    FROM
		(SELECT
			ods.id,
			ods.time_id_fk,
			ods.deal_info_status,
			ods.deal_info_type,
			ods.deal_info_type1,
			ods.deal_info_type2,
			ods.is_revoke_business,
			ods.sys_office_name,
			ods.company_name,
		    ods.city,
		    ods.district
		FROM
			${hiveconf:hivedb1}.work_deal_info_etl AS work_deal_info_etl
		LEFT JOIN
		(SELECT
			CONCAT(WORK_DEAL_INFO.ID,'A') AS ID,
			FROM_UNIXTIME(UNIX_TIMESTAMP(WORK_DEAL_INFO.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
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
			CASE WORK_DEAL_INFO.deal_info_type WHEN 0 THEN '新增' WHEN 1 THEN '更新' WHEN 11 THEN '业务更新' ELSE '其他' END AS deal_info_type,
			CASE WORK_DEAL_INFO.deal_info_type1 WHEN 2 THEN '遗失补办' WHEN 3 THEN '损坏更新' ELSE '其他' END AS deal_info_type1,
			CASE WORK_DEAL_INFO.deal_info_type2 WHEN 4 THEN '变更' ELSE '其他' END AS deal_info_type2,
			CASE WORK_DEAL_INFO.is_revoke_business WHEN 1 THEN '吊销业务' ELSE '非吊销业务' END AS is_revoke_business,
		    SYS_OFFICE.NAME AS sys_office_name,
			work_company.company_name,
			work_company.city,
			work_company.district	
		FROM
			${hiveconf:hivedb3}.WORK_DEAL_INFO AS WORK_DEAL_INFO
		LEFT JOIN
		    ${hiveconf:hivedb3}.CONFIG_APP AS CONFIG_APP
		ON
		    WORK_DEAL_INFO.APP_ID = CONFIG_APP.ID
		LEFT JOIN
			${hiveconf:hivedb3}.SYS_OFFICE AS SYS_OFFICE
		ON 
			WORK_DEAL_INFO.OFFICE_ID = SYS_OFFICE.ID
		LEFT JOIN
			${hiveconf:hivedb3}.work_company AS work_company
		ON
			WORK_DEAL_INFO.WORK_COMPANY_ID = work_company.id
		UNION ALL
		SELECT
			CONCAT(CertUpdate.ID,'B') AS ID,
			FROM_UNIXTIME(UNIX_TIMESTAMP(CertUpdate.AddInTime),'yyyy-MM-dd HH:mm') AS time_id_fk,
		    NULL AS deal_info_status,
			'更新' AS deal_info_type,
		    NULL AS deal_info_type1,
		    NULL AS deal_info_type2,
			CASE CertUpdate.CertUpdate_deleteTag WHEN '是' THEN '吊销业务' ELSE '非吊销业务' END AS is_revoke_business,
			NULL AS sys_office_name,
		    t6.company_name, 
		    t6.city,
			t6.district   
		FROM
		${hiveconf:hivedb3}.CertUpdate AS CertUpdate
		LEFT JOIN
			(SELECT 
				t5.contact_name,
				t5.company_id,
				work_company.company_name,
				work_company.city,
				work_company.district
			FROM
				(SELECT * FROM
					(SELECT
						ID,
						RANK() OVER (PARTITION BY contact_name ORDER BY id) NUM,
						contact_name,
						company_id
					FROM
						${hiveconf:hivedb3}.WORK_USER)t4
				WHERE t4.NUM = 1)t5
			LEFT JOIN
				${hiveconf:hivedb3}.work_company AS work_company
			ON t5.company_id = work_company.id) t6
		ON
		    CertUpdate.CertCN = t6.CONTACT_NAME)ods
		ON
			ods.id = work_deal_info_etl.id
		UNION ALL
		SELECT 
                id,
                time_id_fk,
                deal_info_status,
                deal_info_type,
                deal_info_type1,
                deal_info_type2,
                is_revoke_business,
                sys_office_name,
                company_name,
                city,
                district
                FROM
			${hiveconf:hivedb1}.work_deal_info_etl)t2
	GROUP BY 
		id,
		time_id_fk,
		deal_info_status,
		deal_info_type,
		deal_info_type1,
		deal_info_type2,
		is_revoke_business,
		sys_office_name,
		company_name,
	    city,
	    district) t3
WHERE NUM = 1;
