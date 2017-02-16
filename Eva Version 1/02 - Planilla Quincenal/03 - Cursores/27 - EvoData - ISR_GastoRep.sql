/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:34 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ISR_GastoRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ISR_GastoRep','Calcula la renta del gasto de representacion','select 0 codemp, 0.00 salario_quincenal, 0.00 isr_anual, 0.00 isr_quincenal, 0.00 rag_retenido, 0.00 rag_acumulado, 0.00 rag_proyectado, 0.00 rag_desc_legal, 0.00 rag_periodos_restantes','declare @codcia int, @codrsa int, @codpai varchar(2), @codppl int, @codtpl_ordinario int, @codtpl int, @codtpl_vacaciones int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$
set @codtpl = $$CODTPL$$
set @codrsa = gen.get_valor_parametro_int (''CodigoRubroGastoRep'',null,null,@codcia,null)
set @codtpl_ordinario = isnull(gen.get_valor_parametro_int (''CodigoPlanillaQuincenal'',null,null,@codcia,null),0)
set @codtpl_vacaciones= isnull(gen.get_valor_parametro_int (''CodigoPlanillaVacacion'',null,null,@codcia,null),0)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select codemp, 
	   salario_quincenal, 
	   salario_anual, 
	   isr_anual, 
	   (case when convert(numeric(12,2), ((isr_anual - rag_retenido) / rag_periodos_restantes)) < 0 then 0 else convert(numeric(12,2), ((isr_anual - rag_retenido) / rag_periodos_restantes)) end) isr_quincenal, 
	   rag_retenido, 
	   rag_acumulado, 
	   rag_proyectado, 
	   rag_desc_legal, 
	   rag_periodos_restantes
from (
select codemp, 
	   salario_anual, 
	   salario_quincenal, 
	   convert(numeric(12,2), (salario_anual - excedente) * porcentaje / 100 + valor) isr_anual, 
	   rag_retenido, 
	   rag_acumulado, 
	   rag_proyectado, 
	   rag_desc_legal, 
	   rag_periodos_restantes
from gen.get_valor_rango_parametro(''TablaRentaMensualGastoRep'', @codpai, null, null, null, null),
	(select rag_codemp codemp, 
			convert(numeric(12,2), rag_acumulado + rag_proyectado + convert(numeric(12,2), ese_valor / 2.00) * (case when @codtpl in (@codtpl_ordinario, @codtpl_vacaciones) then isnull(dva_dias / 15, 1) else 0 end) - rag_desc_legal) salario_anual, 
			convert(numeric(12,2), ese_valor / 2.00) salario_quincenal, rag_retenido, rag_periodos_restantes
	, rag_acumulado, rag_proyectado, rag_desc_legal
	from sal.rag_renta_anual_panama_gr
	join exp.ese_estructura_sal_empleos
	on ese_codemp = rag_codemp
	left join (
		select vac_codemp, isnull(sum(isnull(dva_dias, 0)), 0) dva_dias
		from acc.dva_dias_vacacion
		join acc.vac_vacaciones
		on vac_codigo = dva_codvac
		where dva_codppl = @codppl
		group by vac_codemp
	) vacaciones
	on vac_codemp = rag_codemp
	where ese_estado = ''V''
	and ese_codrsa = @codrsa
	and rag_codcia = @codcia
	and rag_codppl = @codppl
	) v
where salario_anual >= inicio
and salario_anual <= fin
) w
order by codemp','codemp','TodosExcluyendo',0,0);


commit transaction;

