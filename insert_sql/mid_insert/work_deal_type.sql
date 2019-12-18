SET hive.auto.convert.join=false;
use ${hiveconf:cboard_db};
insert into table work_deal_type partition (ymd="${hiveconf:ymd}")
select
    t5.deal_info_type,
    t6.year,
    t6.month,
    t6.season,
    count(*) as number
from
    (select
        t1.time_id_fk,
        t1.deal_info_type
    from ${hiveconf:etl_db}.work_deal_info as t1
    union all
    select
        t2.time_id_fk,
        t2.deal_info_type1 as deal_info_type
    from ${hiveconf:etl_db}.work_deal_info as t2
    union all
    select
        t3.time_id_fk,
        t3.deal_info_type2 as deal_info_type
    from ${hiveconf:etl_db}.work_deal_info as t3
    union all
    select
        t4.time_id_fk,
        t4.is_revoke_business as deal_info_type
    from ${hiveconf:etl_db}.work_deal_info as t4) as t5

left join ${hiveconf:etl_db}.time_dimension as t6
on t5.time_id_fk = t6.id
group by
    t5.deal_info_type,
    t6.year,
    t6.month,
    t6.season;