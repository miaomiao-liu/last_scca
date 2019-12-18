SET hive.auto.convert.join=false;
use ${hiveconf:dbName}; 
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	id,
	parent_id,
	parent_ids,
	area_id,
	code,
	name AS sys_office_name,
	(CASE TYPE WHEN 1 THEN '公司' WHEN 2 THEN '部门' WHEN 3 THEN '小组' ELSE '其他' END) AS sys_office_type,
	(CASE GRADE WHEN 1 THEN '一级' WHEN 2 THEN '二级' WHEN 3 THEN '三级' WHEN 4 THEN '四级' ELSE '其他' END) AS grade,
	address AS sys_office_address,
	zip_code,
	master,
	phone AS sys_office_phone,
	fax,
	email AS sys_office_email,
	create_by,
	create_date,
	update_by,
	update_date,
	remarks,
	del_flag,
	onfous,
	area_name
from ${hiveconf:odsDB}.sys_office;
