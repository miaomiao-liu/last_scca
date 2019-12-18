SET hive.auto.convert.join=false;
SELECT 
    COUNT(*)
FROM
    (SELECT
        COUNT(*) AS NUM
    FROM
        (SELECT 
            t2.i_xin_id_fk,
            t2.access_type,
            t2.time_id_fk,
            t2.project_name
        FROM 
            ${hiveconf:hivedb1}.cert_use_info_etl AS cert_use_info_etl
        LEFT JOIN
            (SELECT
                IXIN_DATA.id AS i_xin_id_fk,
                (CASE  IXIN_DATA.access_type WHEN 0 THEN '插入' WHEN 1 THEN '签名' ELSE '其他' END) AS access_type,
                FROM_UNIXTIME(UNIX_TIMESTAMP(IXIN_DATA.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
                CONFIG_APP.APP_NAME AS project_name
                FROM
                ${hiveconf:hivedb3}.IXIN_DATA AS IXIN_DATA
                
            LEFT JOIN
                ${hiveconf:hivedb3}.CONFIG_APP AS CONFIG_APP
            ON
                IXIN_DATA.APP_ID = CONFIG_APP.ID)t2
        ON
            cert_use_info_etl.i_xin_id_fk=t2.i_xin_id_fk
        UNION ALL
        SELECT 
           i_xin_id_fk,
           access_type,
           time_id_fk,
           project_name
        FROM
            ${hiveconf:hivedb1}.cert_use_info_etl) t3
    GROUP BY i_xin_id_fk,access_type,time_id_fk,project_name) t4
WHERE NUM = 1;
