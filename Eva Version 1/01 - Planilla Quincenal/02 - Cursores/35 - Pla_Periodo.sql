/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:37 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Pla_Periodo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codcia],[fcu_field_codppl],[fcu_field_codtpl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Pla_Periodo','Pla_Periodo','select tpl_codcia PPL_CODCIA, PPL_CODTPL, ppl_codigo PPL_CODPPL, 
	   PPL_FECHA_INI, PPL_FECHA_FIN, PPL_FECHA_PAGO, 
	   PPL_ESTADO, PPL_FRECUENCIA, ppl_mes PPL_MES_CONT, 
	   ppl_anio ppl_anio_cont, TPL_CODIGO, TPL_DESCRIPCION,
	   TPL_APLICACION, TPL_TOTAL_PERIODOS
	from sal.ppl_periodos_planilla 
	join sal.tpl_tipo_planilla on ppl_codtpl = tpl_codigo
	where tpl_codcia < 0','select tpl_codcia PPL_CODCIA, PPL_CODTPL, ppl_codigo PPL_CODPPL, 
	   PPL_FECHA_INI, PPL_FECHA_FIN, PPL_FECHA_PAGO, 
	   PPL_ESTADO, PPL_FRECUENCIA, ppl_mes PPL_MES_CONT, 
	   ppl_anio ppl_anio_cont, TPL_CODIGO, TPL_DESCRIPCION,
	   TPL_APLICACION, TPL_TOTAL_PERIODOS
	from sal.ppl_periodos_planilla 
	join sal.tpl_tipo_planilla on ppl_codtpl = tpl_codigo
	where tpl_codcia = $$CODCIA$$
    and ppl_codtpl = $$CODTPL$$
	and ppl_codigo = $$CODPPL$$','tpl_codcia','ppl_codppl','tpl_codigo','TodosExcluyendo',0,0);


commit transaction;

