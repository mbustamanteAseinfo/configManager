/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:35 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'pagos_vacacion_estaquincena';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','pagos_vacacion_estaquincena','pagos_vacacion_estaquincena','select 
    ppl_codtpl dpv_codtpl, ppl_codigo dpv_codpla, vac_codemp dpv_codemp, dva_dias dpv_dias, ''A'' dpv_estado 
from acc.dva_dias_vacacion
join acc.vac_vacaciones ON vac_codigo = dva_codvac
join sal.ppl_periodos_planilla on ppl_codigo = dva_codppl
where ppl_codigo = 0','declare @fini datetime, @ffin datetime, @codppl int

set @codppl = $$CODPPL$$

select @fini = ppl_fecha_ini, @ffin = ppl_fecha_fin
from sal.ppl_periodos_planilla
where ppl_codigo = @codppl

select ppl_codtpl dpv_codtpl, @codppl dpv_codpla, vac_codemp dpv_codemp, dva_dias dpv_dias, ''A'' dpv_estado
from acc.dva_dias_vacacion
join acc.vac_vacaciones
on vac_codigo = dva_codvac
join sal.ppl_periodos_planilla
on ppl_codigo = dva_codppl
where (@fini >= dva_desde and @fini <= dva_hasta)
and (@ffin >= dva_desde and @fini<= dva_hasta)
and dva_pagadas = 0','dpv_codemp','TodosExcluyendo',0,1);


commit transaction;

