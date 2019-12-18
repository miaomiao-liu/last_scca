SET hive.auto.convert.join=false;
SELECT 
    COUNT(*)
FROM
    (SELECT
        COUNT(*) AS NUM
    FROM
        (SELECT
            ods.id,
            ods.qz_nx,
            ods.qz_zt,
            ods.qz_sh_zt,
            ods.time_id_fk
        FROM
            ${hiveconf:hivedb1}.s_eseal_info_etl AS s_eseal_info_etl
        LEFT JOIN
            (SELECT 
                S_ESEAL.id,
                S_ESEAL.qz_nx,
                CASE S_ESEAL.qz_zt  WHEN 0 THEN '启用'
                            WHEN 1 THEN '不可'
                            WHEN 2 THEN '注销'
                            WHEN 3 THEN '变更'
                            WHEN 4 THEN '续期'
                            ELSE '其他'
                            END AS qz_zt,
                CASE S_ESEAL.qz_sh_zt   WHEN 0 THEN '未审核'
                            WHEN 1 THEN '审核未通过'
                            WHEN 2 THEN '审核通过'
                            WHEN 3 THEN '待审核'
                            ELSE '其他'
                            END AS qz_sh_zt,            
                FROM_UNIXTIME(UNIX_TIMESTAMP(S_ESEAL.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
                t5.cert_type
            FROM
                ${hiveconf:hivedb3}.S_ESEAL AS S_ESEAL
            LEFT JOIN
                (SELECT
                    t1.QZ_ID,
                    t3.certification_type AS cert_type
                FROM
                    (SELECT
                        t2.QZ_ID,
                        t2.QZ_ZS_ID
                    FROM
                        (SELECT
                            ROW_NUMBER() OVER(PARTITION BY S_ESEAL_CERT_EC.QZ_ID ORDER BY S_ESEAL_CERT.QZ_ZS_ID)ID,
                            S_ESEAL_CERT_EC.QZ_ID,
                            S_ESEAL_CERT.QZ_ZS_ID
                        FROM
                            ${hiveconf:hivedb3}.S_ESEAL_CERT_EC AS S_ESEAL_CERT_EC
                        JOIN
                            ${hiveconf:hivedb3}.S_ESEAL_CERT AS S_ESEAL_CERT
                        ON
                            S_ESEAL_CERT_EC.ZS_ID = S_ESEAL_CERT.ID)t2
                    WHERE 
                        t2.ID = 1)t1
                LEFT JOIN
                    (SELECT 
                        key_table.cert_serialNamber,
                        customer_info.certification_type
                    FROM
                        ${hiveconf:hivedb3}.key_table AS key_table
                    JOIN
                        ${hiveconf:hivedb3}.customer_info AS customer_info
                    ON
                        key_table.customer_id = customer_info.customer_id) t3
                ON
                    regexp_replace(t1.QZ_ZS_ID,' ','') = regexp_replace(t3.cert_serialNamber,' ','')) t5
            ON
                S_ESEAL.ID = t5.QZ_ID)ods
        ON ods.id = s_eseal_info_etl.id
        UNION ALL
        SELECT 
        id,
        qz_nx,
        qz_zt,
        qz_sh_zt,
        time_id_fk
        FROM
            ${hiveconf:hivedb1}.s_eseal_info_etl)t6
GROUP BY 
    id,
    qz_nx,
    qz_zt,
    qz_sh_zt,
    time_id_fk)t7
WHERE NUM = 1;
