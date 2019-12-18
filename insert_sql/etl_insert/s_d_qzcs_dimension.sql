SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	id,
	qz_cs_mc,
	qz_cs_bz,
	qz_cs_dm
from ${hiveconf:odsDB}.s_d_qzcs;