/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:34 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ISR_GastoRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ISR_GastoRep','Calcula la renta del gasto de representacion','select 0 codemp, 0.00 salario_quincenal, 0.00 isr_anual, 0.00 isr_quincenal, 0.00 rag_retenido, 0.00 rag_acumulado, 0.00 rag_proyectado, 0.00 rag_desc_legal, 0.00 rag_periodos_restantes','declare @codcia int, @codrsa int, @codpai varchar(2), @codppl int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$
set @codrsa = gen.get_valor_parametro_int (''PA_CodigoRubroGastoRep'',null,null,@codcia,null)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select codemp, salario_quincenal, salario_anual, isr_anual, convert(numeric(12,2), ((isr_anual - rag_retenido) / rag_periodos_restantes)) isr_quincenal, rag_retenido, rag_acumulado, rag_proyectado, rag_desc_legal, rag_periodos_restantes
from (
select codemp, salario_anual, salario_quincenal, convert(numeric(12,2), (salario_anual - excedente) * porcentaje / 100 + valor) isr_anual, rag_retenido
, rag_acumulado, rag_proyectado, rag_desc_legal, rag_periodos_restantes
from gen.get_valor_rango_parametro(''PA_TablaRentaMensualGastoRep'', @codpai, null, null, null, null),
(select rag_codemp codemp, rag_acumulado + rag_proyectado + convert(numeric(12,2), ese_valor / 2.00) - rag_desc_legal salario_anual, convert(numeric(12,2), ese_valor / 2.00) salario_quincenal, rag_retenido, rag_periodos_restantes
, rag_acumulado, rag_proyectado, rag_desc_legal
from sal.rag_renta_anual_panama_gr
join exp.ese_estructura_sal_empleos
on ese_codemp = rag_codemp
where ese_estado = ''V''
and ese_codrsa = @codrsa
and rag_codcia = @codcia
and rag_codppl = @codppl
) v
where salario_anual >= inicio
and salario_anual <= fin
) w
order by codemp

','codemp','TodosExcluyendo',0,0);


commit transaction;

