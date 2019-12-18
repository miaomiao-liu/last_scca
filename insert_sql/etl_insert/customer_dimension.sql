SET hive.auto.convert.join=false;
use ${hiveconf:dbName};
insert into table ${hiveconf:tbName} partition (ymd="${hiveconf:ymd}")
SELECT
	customer_id AS id,
	proj_name AS customer_proj_name,
	organization_name AS customer_organization_name,
	organization_number,
	organization_boss,
	organization_register_number,
	orgIDtype,
	organization_address,
	organization_post_code,
	organization_email,
	organization_phone,
	organization_fax,
	tax_register_number_nation,
	tax_register_number_native,
	transactor_name,
	transactor_email,
	indentify_card_number,
	indentify_card_type,
	transactor_fixed_phone,
	transactor_fax,
	transactor_mobile_phone,
	customer_input_person,
	certification_type,
	operation_type,
	UpdateByHand,
	request_date,
	other_info,
	customer_primary_num,
	customer_sub_num,
	key_amount,
	TakeChargePerson,
	TakeChargeTime,
	TakeChargeNotes,
	SystemUserID,
	ident_person,
	ident_date,
	ident_result,
	ident_reject_reason,
	IsSpecialTreat,
	SpecialTreatTime,
	SpecialTreatPerson,
	SpecialTreatReason,
	current_status,
	parent_keylife_id,
	id_char_1,
	id_char_2,
	id_char_3,
	ImportSerialNumber,
	ImportTag,
	update_id,
	ServPrice,
	PaymentBy,
	Opt1,
	Opt2,
	Version,
	LogID,
	TreeID,
	TreeNodeName,
	PathName,
	CS_modify_tag,
	CusUserNumber,
	UserPayID,
	Cu_EntryPlace,
	Cu_IdentPlace,
	Cus_CertServiceYears,
	Cus_FreeMonths,
	Cus_identBussSiteId,
	Cus_MoneyRecive,
	Cus_FaPiaoOut,
	Cus_MoneyReviveNoteForContract,
	cus_AccepNum,
	cus_Province,
	cus_City,
	cus_District,
	cus_OrgSecurityCode,
	cus_EntryPlaceID,
	cus_CertExtraDays,
	cus_deleteTag,
	cus_deleteDate,
	cus_deleteReason,
	busiOptTag,
	SCCACustomerIDStr_cus,
	SCCACustomerID_cus,
	SCCACustomerIDpact_cus,
	SCCACustomerIDpactstr_cus,
	cusAreaId,
	busiOptTagNote,
	cus_mobile_seal_id_Dianjun
from ${hiveconf:odsDB}.customer_info;