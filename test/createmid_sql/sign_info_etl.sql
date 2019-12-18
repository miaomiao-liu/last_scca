SET hive.auto.convert.join=false;
DROP TABLE IF EXISTS ${hiveconf:hivedb1}.sign_info_etl;
CREATE TABLE ${hiveconf:hivedb1}.sign_info_etl AS
SELECT
	t1.id,
	t1.sign_enterprise_name,
	t1.time_id_fk,
	t1.businesstype,
	t2.project_name
FROM
	(SELECT * FROM
		(SELECT
			id,
			sign_enterprise_name,
			time_id_fk,
			businesstype,
			project_id_fk,
			rand(12345) AS random
		FROM
			${hiveconf:hivedb2}.sign_info
		WHERE
			ymd="${hiveconf:ymd}")t0
	WHERE random BETWEEN 0 AND 0.01)t1
LEFT JOIN
	${hiveconf:hivedb2}.project_dimension AS t2
ON 
	t1.project_id_fk = t2.id;
