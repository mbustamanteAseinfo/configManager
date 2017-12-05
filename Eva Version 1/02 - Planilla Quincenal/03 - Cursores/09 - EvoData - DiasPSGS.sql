/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:24 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DiasPSGS';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DiasPSGS','DiasPSGS','SELECT 0 CODCIA, 0 CODEMP, 0 DIAS, 0.00 HORAS','declare @codcia int, @codtpl int, @codppl int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

exec pa.proc_cur_DiasPSGS @codcia, @codtpl, @codppl','codemp','codcia','TodosExcluyendo',0,0);


commit transaction;

