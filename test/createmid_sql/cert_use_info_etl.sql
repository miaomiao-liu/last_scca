SET hive.auto.convert.join=false;
DROP TABLE IF EXISTS ${hiveconf:hivedb1}.cert_use_info_etl;
CREATE TABLE ${hiveconf:hivedb1}.cert_use_info_etl AS 
SELECT
	t1.i_xin_id_fk,
	t1.access_type,
	t1.time_id_fk,
	t2.project_name
FROM
	(SELECT * FROM
		(SELECT
			i_xin_id_fk,
			access_type,
			time_id_fk,
			project_id_fk,
			rand(12345) AS random
		FROM
			${hiveconf:hivedb2}.cert_use_info
		WHERE
			ymd="${hiveconf:ymd}")t0
	WHERE random BETWEEN 0 AND 0.0001)t1
LEFT JOIN
	${hiveconf:hivedb2}.project_dimension AS t2
ON 
	t1.project_id_fk = t2.id;
