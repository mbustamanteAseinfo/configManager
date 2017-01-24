/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:13 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'CuotasDescuentosCiclicos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_field_codtpl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','CuotasDescuentosCiclicos','CuotasDescuentosCiclicos','select *
from sal.cdc_cuotas_descuento_ciclico
join sal.dcc_descuentos_ciclicos
on cdc_coddcc = dcc_codigo
where 1 = 2','select *
from sal.cdc_cuotas_descuento_ciclico
join sal.dcc_descuentos_ciclicos
on cdc_coddcc = dcc_codigo
where cdc_codppl = $$CODPPL$$
','dcc_codemp','cdc_codppl','dcc_codtpl','TodosExcluyendo',0,1);


commit transaction;

