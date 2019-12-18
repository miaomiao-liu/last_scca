SET hive.auto.convert.join=false;
DROP TABLE IF EXISTS ${hiveconf:hivedb1}.evidence_info_etl;
CREATE TABLE ${hiveconf:hivedb1}.evidence_info_etl AS
SELECT
	t1.id,
	t1.evidence_enterprise_name,
	t1.business_type,
	t1.time_id_fk,
	t3.project_name
FROM
	(SELECT * FROM
		(SELECT
			id,
			evidence_enterprise_name,
			business_type,
			time_id_fk,
			client_id_fk,
			project_id_fk,
			rand(12345) AS random
		FROM
			${hiveconf:hivedb2}.evidence_info
		WHERE
			ymd="${hiveconf:ymd}")t0
	WHERE random BETWEEN 0 AND 0.1)t1
LEFT JOIN
	${hiveconf:hivedb2}.client_dimension AS t2
ON
	t1.client_id_fk = t2.id
LEFT JOIN
	${hiveconf:hivedb2}.project_dimension AS t3
ON 
	t1.project_id_fk = t3.id;