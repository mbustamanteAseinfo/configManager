/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:26 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_OtrosDescuentos_AplicaLegal';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_OtrosDescuentos_AplicaLegal','Emp_OtrosDescuentos_AplicaLegal','select *
from sal.ods_otros_descuentos
where 1 = 2','select *
from sal.ods_otros_descuentos
where ods_estado = ''Autorizado''
and ods_ignorar_en_planilla = 0
and ods_codppl = $$CODPPL$$
and ( exists (select dag_codtdc 
				from sal.dag_descuentos_agrupador 
				join sal.agr_agrupadores on agr_codigo = dag_codagr
				where dag_codtdc = ods_codtdc
				and agr_abreviatura in (''BaseCalculoSeguroSocial'',''BaseCalculoSeguroEducativo'',
										  ''DescuentosRentaPTY'',''Agrupador Descuentos Renta GRep PTY'') ) )','ods_codemp','ods_codppl','TodosExcluyendo',0,1);


commit transaction;

