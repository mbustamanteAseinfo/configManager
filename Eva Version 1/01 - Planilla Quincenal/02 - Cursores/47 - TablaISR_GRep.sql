/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:41 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'TablaISR_GRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','TablaISR_GRep','TablaISR_GRep','select 0.00 isr_desde, 0.00 isr_hasta, 0.00 isr_pct, 0.00 isr_excendente, 0.00 isr_valor','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select inicio isr_desde, fin isr_hasta, porcentaje isr_pct, excedente isr_excedente, valor isr_valor
from gen.get_valor_rango_parametro(''TablaRentaMensualGastoRep'', @codpai, null, null, null, null)
','TodosExcluyendo',0,0);


commit transaction;

