/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:38 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RentaAdelantoXIII';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RentaAdelantoXIII','RentaAdelantoXIII','SELECT 0 CODEMP, 0.00 VALOR','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime, @codtdc_renta int, @codtpl_adelanto_xiii int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

select @codtdc_renta = gen.get_valor_parametro_int(''Liq_codtdc_renta'',null,null,@codcia,null)
set @codtpl_adelanto_xiii = 0

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
WHERE ppl_codigo = @codppl

SELECT DSS_CODEMP CODEMP, SUM(DSS_VALOR) VALOR
FROM sal.dss_descuentos
JOIN sal.ppl_periodos_planilla
ON ppl_codigo = dss_codppl
WHERE PPL_CODTPL = @codtpl_adelanto_xiii
AND (PPL_FECHA_INI >= @fecha_ini AND PPL_FECHA_FIN <= @fecha_fin)
AND (PPL_FECHA_FIN >= @fecha_ini AND PPL_FECHA_FIN <= @fecha_fin)
AND DSS_CODTDC = @codtdc_renta
GROUP BY DSS_CODEMP','CODEMP','TodosExcluyendo',0,0);


commit transaction;

