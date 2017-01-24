/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:33 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'IngresosEstaPlanilla';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','IngresosEstaPlanilla','Registro de Ingresos Pagados en Planilla','select * 
  from tmp.inn_ingresos
 where inn_codigo < 0','select * 
  from tmp.inn_ingresos
 where inn_codppl = $$CODPPL$$','inn_codemp','inn_codppl','TodosExcluyendo',0,1);


commit transaction;

