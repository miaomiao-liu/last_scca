SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
    IXIN_DATA.id AS i_xin_id_fk,
    FROM_UNIXTIME(UNIX_TIMESTAMP(IXIN_DATA.CREATE_DATE),'yyyy-MM-dd HH:mm') AS time_id_fk,
    MD5(regexp_replace(IXIN_DATA.CERT_SN,' ','')) AS cert_id_fk,
    MD5(regexp_replace(CONFIG_APP.APP_NAME,' ','')) AS project_id_fk,
    t1.customer_id AS customer_id_fk,
    (CASE  IXIN_DATA.access_type WHEN 0 THEN '插入' WHEN 1 THEN '签名' ELSE '其他' END) AS access_type,
    IXIN_DATA.del_flag,
    IXIN_DATA.access_time
    FROM
    (select * from ${hiveconf:odsDB}.IXIN_DATA where ymd="${hiveconf:ymd}") AS IXIN_DATA 
    LEFT JOIN
    ${hiveconf:odsDB}.CONFIG_APP AS CONFIG_APP
    ON
    IXIN_DATA.APP_ID = CONFIG_APP.ID
LEFT JOIN
    (SELECT 
        key_table.cert_serialNamber,
        key_table.customer_id
        FROM
        	${hiveconf:odsDB}.key_table AS key_table
        WHERE
        	key_table.cert_serialNamber IS NOT NULL) t1
ON
    IXIN_DATA.CERT_SN = t1.cert_serialNamber;