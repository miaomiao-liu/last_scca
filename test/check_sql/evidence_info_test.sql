SET hive.auto.convert.join=false;
SELECT 
    COUNT(*)
FROM
    (SELECT
        COUNT(*) AS NUM
    FROM
        (SELECT
            ods.id,
            ods.evidence_enterprise_name,
            ods.business_type,
            ods.time_id_fk,
            ods.project_name
        FROM
            ${hiveconf:hivedb1}.evidence_info_etl AS evidence_info_etl
        LEFT JOIN 
            (SELECT
                S_EVIDENCE.id,
                S_EVIDENCE.ENTERPRISE_NAME AS evidence_enterprise_name,
                S_EVIDENCE.businesstype AS business_type,
                FROM_UNIXTIME(UNIX_TIMESTAMP(S_EVIDENCE.CREATE_TIME),'yyyy-MM-dd HH:mm') AS time_id_fk,
                S_PROJECTCONFIG.PROJECTNAME AS project_name,
                t1.certification_type AS cert_type
            FROM
            	${hiveconf:hivedb3}.S_EVIDENCE AS S_EVIDENCE
            LEFT JOIN
            	${hiveconf:hivedb3}.S_PROJECTCONFIG AS S_PROJECTCONFIG
            ON
            	S_EVIDENCE.PROJ_ID = S_PROJECTCONFIG.PROJ_ID
            LEFT JOIN
                (SELECT 
                    key_table.cert_serialNamber,
                    customer_info.certification_type
                FROM
                    ${hiveconf:hivedb3}.key_table AS key_table
                JOIN
                    ${hiveconf:hivedb3}.customer_info AS customer_info
                ON 
                    key_table.customer_id = customer_info.customer_id)t1
            ON
		regexp_replace(t1.cert_serialNamber,' ','') = regexp_replace(S_EVIDENCE.cert_serialnumber,' ',''))ods
        ON
            evidence_info_etl.id = ods.id
        UNION ALL
        SELECT
        id,
        evidence_enterprise_name,
        business_type,
        time_id_fk,
        project_name
        FROM
            ${hiveconf:hivedb1}.evidence_info_etl)t3
        GROUP BY id,evidence_enterprise_name,business_type,time_id_fk,project_name)t4
WHERE NUM = 1;
