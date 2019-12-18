SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT * from
	(SELECT
		(CASE
			WHEN S_PROJECTCONFIG.PROJECTNAME IS NOT NULL THEN MD5(regexp_replace(S_PROJECTCONFIG.PROJECTNAME,' ',''))
			WHEN CONFIG_APP.APP_NAME IS NOT NULL THEN MD5(regexp_replace(CONFIG_APP.APP_NAME,' ',''))
			WHEN project.proj_name IS NOT NULL THEN MD5(regexp_replace(project.proj_name,' ',''))
			WHEN sign_project.proj_name IS NOT NULL THEN MD5(regexp_replace(sign_project.proj_name,' ',''))
			END) AS id,
		(CASE	
			WHEN S_PROJECTCONFIG.PROJECTNAME IS NOT NULL THEN S_PROJECTCONFIG.PROJECTNAME
			WHEN CONFIG_APP.APP_NAME IS NOT NULL THEN CONFIG_APP.APP_NAME
			WHEN project.proj_name IS NOT NULL THEN project.proj_name
			WHEN sign_project.proj_name IS NOT NULL THEN sign_project.proj_name
			END) AS project_name,
		sign_project.pta_id,
		sign_project.proj_text,
		(CASE sign_project.proj_status WHEN 0 THEN '停用' WHEN 1 THEN '正常' ELSE '其他' END) AS proj_status,
		project.proj_manager,
		project.proj_auth_incharge,
		project.proj_init_date,
		project.current_number_to,
		S_PROJECTCONFIG.project_ip,
		S_PROJECTCONFIG.appid,
		CONFIG_APP.DEL_FLAG AS project_del_flag,
		CONFIG_APP.UPDATE_DATE AS project_update_date,
		CONFIG_APP.CREATE_BY AS project_create_by,
		CONFIG_APP.UPDATE_BY AS project_update_by,
		CONFIG_APP.support_common,
		CONFIG_APP.alias,
		CONFIG_APP.config_product_type,
		(CASE CONFIG_APP.pay_method WHEN 1 THEN '窗口支付' WHEN 2 THEN '网上支付' WHEN 3 THEN '窗口支付或网上支付' ELSE '其他' END) AS pay_method,
		(CASE CONFIG_APP.post_method WHEN 1 THEN '自取' WHEN 2 THEN '邮寄' WHEN 3 THEN '自取或邮寄' ELSE '其他' END) AS post_method,
		(CASE   
			WHEN sign_project.create_time IS NOT NULL THEN sign_project.create_time
			WHEN CONFIG_APP.CREATE_DATE IS NOT NULL THEN CONFIG_APP.CREATE_DATE
			ELSE NULL
			END) AS project_create_time
	FROM ${hiveconf:odsDB}.CONFIG_APP AS CONFIG_APP
	
	FULL JOIN
         ${hiveconf:odsDB}.S_PROJECTCONFIG AS S_PROJECTCONFIG
	ON
		TRIM(CONFIG_APP.APP_NAME) = TRIM(S_PROJECTCONFIG.PROJECTNAME)
	FULL JOIN
	    ${hiveconf:odsDB}.project AS project
	ON
		TRIM(CONFIG_APP.APP_NAME) = TRIM(project.proj_name)
	FULL JOIN
	    ${hiveconf:odsDB}.sign_project AS sign_project
	ON
		TRIM(CONFIG_APP.APP_NAME) = TRIM(sign_project.proj_name)
	) t3
WHERE LOWER(project_name) NOT IN ('','null');
