SET hive.auto.convert.join=false;
SELECT 
    COUNT(*)
FROM
    (SELECT
        COUNT(*) AS NUM
    FROM
        (SELECT
            ods.id,
            ods.sign_enterprise_name,
            ods.time_id_fk,
            ods.businesstype,
            ods.project_name
        FROM
            ${hiveconf:hivedb1}.sign_info_etl
        LEFT JOIN
            (SELECT 
            	sign_evidence.id,
            	sign_evidence.enterprise_name AS sign_enterprise_name,
            	FROM_UNIXTIME(UNIX_TIMESTAMP(sign_evidence.create_time),'yyyy-MM-dd HH:mm') AS time_id_fk,
            	sign_evidence.businesstype,
            	sign_project.proj_name AS project_name,
            	t1.certification_type AS cert_type
            FROM
            ${hiveconf:hivedb3}.sign_evidence AS sign_evidence
            LEFT JOIN
            ${hiveconf:hivedb3}.sign_project AS sign_project
            ON
            sign_evidence.proj_id = sign_project.proj_id
            LEFT JOIN
            	(SELECT 
                    key_table.cert_serialNamber,
                    customer_info.certification_type
                FROM
                    ${hiveconf:hivedb3}.key_table AS key_table
                JOIN
                    ${hiveconf:hivedb3}.customer_info AS customer_info
                ON 
                    key_table.customer_id = customer_info.customer_id) t1
            ON
                regexp_replace(sign_evidence.CERT_SERIALNUMBER,' ','') = regexp_replace(t1.cert_serialNamber,' ',''))ods
        ON  ods.id = sign_info_etl.id
        UNION ALL
        SELECT
        id,
        sign_enterprise_name,
        time_id_fk,
        businesstype,
        project_name
        FROM
            ${hiveconf:hivedb1}.sign_info_etl AS sign_info_etl)t2
GROUP BY
    id,
    sign_enterprise_name,
    time_id_fk,
    businesstype,
    project_name)t3
WHERE NUM = 1;
