/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:41 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'TNT_Extenso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','TNT_Extenso','TNT_Extenso','SELECT *
FROM sal.tnn_tiempos_no_trabajados
JOIN sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
WHERE PPL_CODTPL = @codtpl
AND PPL_CODIGO = @codppl

SELECT *
FROM sal.tnn_tiempos_no_trabajados
JOIN sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia = @codcia
AND (@fecha_ini >= TNN_FECHA_DEL AND @fecha_ini <= TNN_FECHA_AL)
AND (@fecha_fin >= TNN_FECHA_DEL AND @fecha_fin <= TNN_FECHA_AL)','tnn_codemp','tnt_codcia','TodosExcluyendo',0,0);


commit transaction;

