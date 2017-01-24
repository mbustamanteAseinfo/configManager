/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:13 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'CuotasIngresosCiclicos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','CuotasIngresosCiclicos','CuotasIngresosCiclicos','select *
from sal.cic_cuotas_ingreso_ciclico
join sal.igc_ingresos_ciclicos
on cic_codigc = igc_codigo
where 1 = 2','select *
from sal.cic_cuotas_ingreso_ciclico
join sal.igc_ingresos_ciclicos
on cic_codigc = igc_codigo
where cic_codppl = $$CODPPL$$
--and sal.empleado_en_gen_planilla(''$$SESSIONID$$'', igc_codemp) = 1
and cic_valor_cuota > 0','','cic_codppl','TodosExcluyendo',0,1);


commit transaction;

