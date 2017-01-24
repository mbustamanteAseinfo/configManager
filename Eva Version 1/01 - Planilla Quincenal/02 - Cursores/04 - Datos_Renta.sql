/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:13 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Datos_Renta';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Datos_Renta','Datos_Renta','select *
from sal.rap_renta_anual_panama 
where 1  = 0','select *
from sal.rap_renta_anual_panama
where rap_codcia = $$CODCIA$$
and rap_codtpl = $$CODTPL$$
and rap_codppl = $$CODPPL$$
','rap_codemp','rap_codppl','TodosExcluyendo',0,1);


commit transaction;

