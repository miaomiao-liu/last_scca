SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table cert_use_i_xin partition (ymd="${hiveconf:ymd}")
select 
    upper(t2.ie_version),
    t3.year,
    t3.season,
    t3.month,
    count(*) as number
from ${hiveconf:etl_db}.cert_use_info as t1 
left join ${hiveconf:etl_db}.i_xin_dimension as t2
on t1.i_xin_id_fk = t2.id 
left join ${hiveconf:etl_db}.time_dimension as t3
on t1.time_id_fk = t3.id
group by
    upper(t2.ie_version),
    t3.year,
    t3.season,
    t3.month;
