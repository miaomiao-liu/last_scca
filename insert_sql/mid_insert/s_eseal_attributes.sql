SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table s_eseal_attributes partition (ymd="${hiveconf:ymd}")
select
    t1.qz_nx,
    t1.qz_zt,
    t1.qz_sh_zt,
    t2.year,
    t2.season,
    t2.month,
    count(*) as number
from ${hiveconf:etl_db}.s_eseal_info as t1
left join ${hiveconf:etl_db}.time_dimension as t2
on t1.time_id_fk = t2.id
group by
    t1.qz_nx,
    t1.qz_zt,
    t1.qz_sh_zt,
    t2.year,
    t2.season,
    t2.month;