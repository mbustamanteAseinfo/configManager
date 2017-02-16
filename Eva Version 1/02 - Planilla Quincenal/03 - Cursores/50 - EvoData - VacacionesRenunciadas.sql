/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:41 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'VacacionesRenunciadas';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','VacacionesRenunciadas','VacacionesRenunciadas','select vac_codemp, isnull(sum(dva_dias), 0.00) dva_dias
from acc.dva_dias_vacacion
join acc.vac_vacaciones on vac_codigo = dva_codvac
left join pa.dpv_dias_pago_vacacion on dpv_codvac = vac_codigo and dpv_coddva = dva_codigo 
where dva_codppl < 0
and dva_pagadas = 1
group by vac_codemp','declare @codppl int, @codtpl int, @codcia int, @fecha_ini datetime, @fecha_fin datetime, @codtpl_vacacion int, @codppl_vacacion int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SET @CODTPL_VACACION = gen.get_valor_parametro_int(''CodigoPlanillaVacacion'', null, null, @CODCIA, null)

if @codtpl = @CODTPL_VACACION 
   set  @codppl_vacacion =  @codppl
ELSE 
BEGIN
	SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
	FROM sal.ppl_periodos_planilla
	JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	WHERE ppl_codigo = @codppl

	/*OBTENGO EL CODIGO DE PLANILLA DE VACACIONES EN ESTADO GENERADO*/
	select @codppl_vacacion = ppl_codigo
	FROM sal.ppl_periodos_planilla
	join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	WHERE tpl_codcia = @codcia
	AND tpl_codigo = @CODTPL_VACACION -- Tipo de planilla Vacaciones
	AND PPL_FECHA_INI >= @FECHA_INI
	AND PPL_FECHA_FIN <= @FECHA_FIN
END

/*OBTENGO LOS DIAS QUE FUERON RENUNCIADOS*/
select vac_codemp, isnull(sum(dpv_dias), 0.00) dva_dias
from pa.dpv_dias_pago_vacacion
join acc.vac_vacaciones on vac_codigo = dpv_codvac
join acc.dva_dias_vacacion on dva_codigo = dpv_coddva
where dpv_codppl = @codppl_vacacion
and dva_pagadas = 1
group by vac_codemp','vac_codemp','TodosExcluyendo',0,0);


commit transaction;

