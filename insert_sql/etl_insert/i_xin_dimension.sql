SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
    id,
    ie_version,
    cpu_id,
    ixin_version,
    ip,
    os_version
FROM ${hiveconf:odsDB}.IXIN_DATA
where ymd="${hiveconf:ymd}"; 