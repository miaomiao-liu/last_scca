SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table work_deal_project partition (ymd="${hiveconf:ymd}")
select 
    t2.project_name,
    t3.year,
    t3.season,
    t3.month,
    count(*) as number
from ${hiveconf:etl_db}.work_deal_info as t1
left join ${hiveconf:etl_db}.project_dimension as t2
on t1.project_id_fk = t2.id
left join ${hiveconf:etl_db}.time_dimension as t3
on t1.time_id_fk = t3.id
group by
    t2.project_name,
    t3.year,
    t3.season,
    t3.month;