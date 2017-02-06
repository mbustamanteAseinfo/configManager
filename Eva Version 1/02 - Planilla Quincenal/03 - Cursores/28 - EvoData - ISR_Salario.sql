/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:34 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ISR_Salario';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ISR_Salario','Calcula la renta del salario','select 0 codemp, 0.00 salario_quincenal, 0.00 isr_anual, 0.00 isr_quincenal, 0.00 rap_retenido, 0.00 rap_acumulado, 0.00 rap_proyectado, 0.00 rap_desc_legal, 0.00 rap_periodos_restantes','declare @codcia int, @codrsa int, @codpai varchar(2), @codppl int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$
set @codrsa = gen.get_valor_parametro_int (''PA_CodigoRubroSalario'',null,null,@codcia,null)

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
select codemp, salario_anual, salario_quincenal, convert(numeric(12,2), (salario_anual - excedente) * porcentaje / 100 + valor) isr_anual, rap_retenido
, rap_acumulado, rap_proyectado, rap_desc_legal, rap_periodos_restantes
from gen.get_valor_rango_parametro(''PA_TablaRentaMensual'', @codpai, null, null, null, null),
(select rap_codemp codemp, rap_acumulado + rap_proyectado + convert(numeric(12,2), ese_valor / 2.00) * isnull(dva_dias / 15, 1) - rap_desc_legal salario_anual, convert(numeric(12,2), ese_valor / 2.00) salario_quincenal, rap_retenido, rap_periodos_restantes
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
','codemp','TodosExcluyendo',0,0);


commit transaction;

