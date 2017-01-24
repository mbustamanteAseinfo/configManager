update sal.fcu_formulacion_cursores
set fcu_select_run = 'declare @codcia int, @codrsa int, @codpai varchar(2), @codppl int, @codtpl_ordinario int, @codtpl int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$
set @codtpl = $$CODTPL$$
set @codrsa = gen.get_valor_parametro_int (''CodigoRubroSalario'',null,null,@codcia,null)
set @codtpl_ordinario = isnull(gen.get_valor_parametro_int (''CodigoPlanillaQuincenal'',null,null,@codcia,null),0)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select codemp, 
	   salario_quincenal, 
	   salario_anual, 
	   isr_anual, 
	   (case when convert(numeric(12,2), ((isr_anual - rap_retenido) / rap_periodos_restantes)) < 0 then 0 else convert(numeric(12,2), ((isr_anual - rap_retenido) / rap_periodos_restantes)) end) isr_quincenal, 
	   rap_retenido, 
	   rap_acumulado, 
	   rap_proyectado, 
	   rap_desc_legal, 
	   rap_periodos_restantes
from (
select codemp, 
	   salario_anual, 
	   salario_quincenal, 
	   convert(numeric(12,2), (salario_anual - excedente) * porcentaje / 100 + valor) isr_anual, 
	   rap_retenido, 
	   rap_acumulado, 
	   rap_proyectado, 
	   rap_desc_legal, 
	   rap_periodos_restantes
from gen.get_valor_rango_parametro(''TablaRentaMensual'', @codpai, null, null, null, null),
	(select rap_codemp codemp, 
			convert(numeric(12,2), rap_acumulado + rap_proyectado + convert(numeric(12,2), ese_valor / 2.00) * (case @codtpl when @codtpl_ordinario then isnull(dva_dias / 15, 1) else 0 end) - rap_desc_legal) salario_anual, 
			convert(numeric(12,2), ese_valor / 2.00) salario_quincenal, rap_retenido, rap_periodos_restantes
	, rap_acumulado, rap_proyectado, rap_desc_legal
	from sal.rap_renta_anual_panama
	join exp.ese_estructura_sal_empleos
	on ese_codemp = rap_codemp
	left join (
		select vac_codemp, isnull(sum(isnull(dva_dias, 0)), 0) dva_dias
		from acc.dva_dias_vacacion
		join acc.vac_vacaciones
		on vac_codigo = dva_codvac
		where dva_codppl = @codppl
		group by vac_codemp
	) vacaciones
	on vac_codemp = rap_codemp
	where ese_estado = ''V''
	and ese_codrsa = @codrsa
	and rap_codcia = @codcia
	and rap_codppl = @codppl
	) v
where salario_anual >= inicio
and salario_anual <= fin
) w
order by codemp
'
where fcu_nombre = 'ISR_Salario'
