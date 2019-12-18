SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table sign_attributes partition (ymd="${hiveconf:ymd}")
select 
    t1.businesstype,
    t1.sign_enterprise_name,
    t2.year,
    t2.month,
    t2.season,
    t2.hour,
    count(*) as number
from ${hiveconf:etl_db}.sign_info as t1
left join ${hiveconf:etl_db}.time_dimension as t2
ON t1.time_id_fk = t2.id
group by
    t1.businesstype,
    t1.sign_enterprise_name,
    t2.year,
    t2.month,
    t2.season,
    t2.hour;