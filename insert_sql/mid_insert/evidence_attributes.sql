SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table evidence_attributes partition (ymd="${hiveconf:ymd}")
select 
    t1.evidence_enterprise_name,
    t2.year,
    t2.season,
    t2.month,
    count(*) AS number
from ${hiveconf:etl_db}.evidence_info as t1
left join
${hiveconf:etl_db}.time_dimension as t2
ON t1.time_id_fk = t2.id
GROUP BY
    t1.evidence_enterprise_name,
    t2.year,
    t2.season,
    t2.month;