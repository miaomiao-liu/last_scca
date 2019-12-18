SET hive.auto.convert.join=false;
DROP TABLE IF EXISTS ${hiveconf:hivedb1}.s_eseal_info_etl;
CREATE TABLE ${hiveconf:hivedb1}.s_eseal_info_etl AS
SELECT * FROM
	(SELECT
		id,
		qz_nx,
		qz_zt,
		qz_sh_zt,
		time_id_fk,
		cert_id_fk,
		rand(12345) AS random
	FROM
		${hiveconf:hivedb2}.s_eseal_info
	WHERE
		ymd="${hiveconf:ymd}")t0
WHERE random BETWEEN 0 AND 0.1
