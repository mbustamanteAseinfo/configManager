/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:34 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'MontosPagoVacacion';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','MontosPagoVacacion','Montos para el calculo de pagos de vacacion','select * from pa.mpv_montos_pago_vacacion where mpv_codppl < 0','select * from pa.mpv_montos_pago_vacacion
where mpv_codppl = $$CODPPL$$','mpv_codemp','mpv_codppl','TodosExcluyendo',0,1);


commit transaction;

