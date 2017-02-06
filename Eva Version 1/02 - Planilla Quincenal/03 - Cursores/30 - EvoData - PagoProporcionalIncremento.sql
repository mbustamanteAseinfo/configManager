/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:34 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PagoProporcionalIncremento';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PagoProporcionalIncremento','PagoProporcionalIncremento','SELECT 0 INN_CODCIA, 0 DIN_CODEMP, 0.00 HORAS_PREVIO, 0.00 SALARIO_PREVIO, 0.00 HORAS_ACTUAL, 0.00 SALARIO_ACTUAL
WHERE 1 = 2','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND PPL_CODTPL = @codtpl
AND ppl_codigo = @codppl

SELECT DISTINCT tin_codcia INC_CODCIA, inc_codemp DIN_CODEMP,
       sal.fn_total_horas_laborales_periodo(@codcia, inc_codemp, @fecha_ini, DATEADD(DD, -1, idr_fecha_vigencia)) HORAS_PREVIO,
       sal.fn_total_horas_laborales_periodo_salario(@codcia, inc_codemp, @fecha_ini, DATEADD(DD, -1, idr_fecha_vigencia)) SALARIO_PREVIO,
       sal.fn_total_horas_laborales_periodo(@codcia, inc_codemp, idr_fecha_vigencia, @fecha_fin) HORAS_ACTUAL,
       sal.fn_total_horas_laborales_periodo_salario(@codcia, inc_codemp, idr_fecha_vigencia, @fecha_fin) SALARIO_ACTUAL
FROM acc.idr_incremento_detalle_rubros
JOIN acc.inc_incrementos ON inc_codigo = idr_codinc
JOIN acc.tin_tipos_incremento ON tin_codigo = inc_codtin
WHERE idr_fecha_vigencia > @fecha_ini
AND idr_fecha_vigencia <= @fecha_fin
AND INC_ESTADO = ''A''
AND tin_codcia = @codcia','DIN_CODEMP','INN_CODCIA','TodosExcluyendo',0,0);


commit transaction;

