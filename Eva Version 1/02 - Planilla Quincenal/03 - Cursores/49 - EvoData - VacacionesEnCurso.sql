/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:41 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'VacacionesEnCurso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','VacacionesEnCurso','VacacionesEnCurso','SELECT vac_codemp CODEMP, dva_codppl CODPLA, DVA_DESDE DESDE, DVA_HASTA HASTA, DVA_DIAS DIAS
FROM acc.dva_dias_vacacion
JOIN acc.vac_vacaciones on vac_codigo = dva_codvac
WHERE vac_codigo < 0','declare @codcia int, @codtpl int, @codppl int, @ppl_fecha_ini datetime, @ppl_fecha_fin datetime, @ppl_mes int, @ppl_fecha_pago datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

select @ppl_fecha_ini = ppl_fecha_ini, @ppl_fecha_fin = ppl_fecha_fin, @ppl_mes = ppl_mes, @ppl_fecha_pago = ppl_fecha_pago
from sal.ppl_periodos_planilla
where ppl_codtpl = @codtpl
and ppl_codigo = @codppl

SELECT CODEMP, CODPLA, DESDE, HASTA
FROM (
	SELECT vac_codemp CODEMP, dva_codppl CODPLA, MIN(DVA_DESDE) DESDE, MAX(DVA_HASTA) HASTA, SUM(DVA_DIAS) DIAS
	FROM acc.dva_dias_vacacion
	JOIN acc.vac_vacaciones on vac_codigo = dva_codvac
	WHERE COALESCE(gen.get_pb_field_data(dva_property_bag_data,''TipoVacacion''), ''T'') <> ''R''
	AND COALESCE(dva_codppl, 0) <> 0
	GROUP BY vac_codemp, dva_codppl
) V
WHERE DIAS >= 30
and ((DESDE >= @ppl_fecha_ini and DESDE <= @ppl_fecha_fin)
or (HASTA >= @ppl_fecha_ini and HASTA <= @ppl_fecha_fin)
or (@ppl_fecha_ini >= DESDE AND @ppl_fecha_fin <= HASTA AND @ppl_fecha_fin >= DESDE AND @ppl_fecha_fin <= HASTA))
and ((case when @ppl_mes = 3 then (case when day(desde) = 1 and month(desde) = 2 then 0 else 1 end) else 1 end)) = 1
and HASTA >= @ppl_fecha_pago','codemp','TodosExcluyendo',0,0);


commit transaction;

