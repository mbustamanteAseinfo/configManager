/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:26 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_OtrosIngresos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_OtrosIngresos','Emp_OtrosIngresos','select *
from sal.oin_otros_ingresos
where oin_codppl < 0','select *
from sal.oin_otros_ingresos
where oin_estado = ''Autorizado''
and oin_ignorar_en_planilla = 0
and oin_codppl = $$CODPPL$$','oin_codemp','oin_codppl','TodosExcluyendo',0,1);


commit transaction;

