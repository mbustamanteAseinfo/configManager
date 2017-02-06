/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:27 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_TmpNoTrabajado';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_TmpNoTrabajado','Emp_TmpNoTrabajado','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnt_codcia < 0','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnn_estado = ''Autorizado''
and tnn_ignorar_en_planilla = 0
and tnn_codppl = $$CODPPL$$
and tnt_codcia = $$CODCIA$$','tnn_codemp','tnn_codppl','TodosExcluyendo',0,1);


commit transaction;

