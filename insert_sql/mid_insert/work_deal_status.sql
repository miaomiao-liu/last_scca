SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table work_deal_status partition (ymd="${hiveconf:ymd}")
select
    t1.deal_info_status,
    t2.year,
    t2.season,
    t2.month,
    COUNT(*) AS number
from ${hiveconf:etl_db}.work_deal_info as t1
left join ${hiveconf:etl_db}.time_dimension as t2
on t1.time_id_fk = t2.id
GROUP BY
    t1.deal_info_status,
    t2.year,
    t2.season,
    t2.month;