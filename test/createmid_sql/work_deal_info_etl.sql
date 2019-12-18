SET hive.auto.convert.join=false;
DROP TABLE IF EXISTS ${hiveconf:hivedb1}.work_deal_info_etl;
CREATE TABLE ${hiveconf:hivedb1}.work_deal_info_etl AS 
SELECT
	work_deak_info.id,
	work_deak_info.time_id_fk,
	work_deak_info.deal_info_status,
	work_deak_info.deal_info_type,
	work_deak_info.deal_info_type1,
	work_deak_info.deal_info_type2,
	work_deak_info.is_revoke_business,
	sys_office_dimension.sys_office_name,
	project_dimension.project_name,
	company_dimension.company_name,
    company_dimension.city,
    company_dimension.district
FROM
	(SELECT * FROM
		(SELECT
			id,
			time_id_fk,
			deal_info_status,
			deal_info_type,
			deal_info_type1,
			deal_info_type2,
			is_revoke_business,
			office_id_fk,
			project_id_fk,
			company_id_fk,
			rand(12345) AS random
		FROM
			${hiveconf:hivedb2}.work_deal_info
		WHERE
			ymd="${hiveconf:ymd}")t1
	WHERE random BETWEEN 0 AND 0.001)work_deak_info
LEFT JOIN
	${hiveconf:hivedb2}.sys_office_dimension AS sys_office_dimension
ON
	work_deak_info.office_id_fk = sys_office_dimension.id
LEFT JOIN
	${hiveconf:hivedb2}.project_dimension AS project_dimension
ON 
	work_deak_info.project_id_fk = project_dimension.id
LEFT JOIN
	${hiveconf:hivedb2}.company_dimension AS company_dimension
ON
	work_deak_info.company_id_fk = company_dimension.id;
