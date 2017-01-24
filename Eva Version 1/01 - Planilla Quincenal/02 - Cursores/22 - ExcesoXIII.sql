/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:27 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ExcesoXIII';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ExcesoXIII','ExcesoXIII','SELECT 0 CODCIA, 0 CODEMP, 0.00 EXCESO','Declare @codcia int,
		@codppl int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

SELECT CODCIA, CODEMP, SUM(MONTO) EXCESO
FROM (
   /*SELECT DPX_CODCIA CODCIA, DPX_CODEMP CODEMP, SUM(DPX_VALOR) MONTO
   FROM PLA_DPX_DESC_PENDIENTE_XIII
   JOIN PLA_PPL_PARAM_PLANI
   ON PPL_CODCIA = DPX_CODCIA
   AND PPL_CODTPL = DPX_CODTPL
   AND PPL_CODPLA = DPX_CODPLA
   WHERE PPL_ESTADO = ''A''
   GROUP BY DPX_CODCIA, DPX_CODEMP
   UNION*/
   SELECT @codcia CODCIA, DSS_CODEMP CODEMP, SUM(DSS_VALOR) * -1 MONTO
   FROM sal.dss_descuentos
   JOIN sal.ppl_periodos_planilla
   ON ppl_codigo = dss_codppl
   WHERE DSS_CODTDC = isnull(gen.get_valor_parametro_int(''CodigoTDCExcesoXIII'',null,null,@codcia,null), 0) -- PAGO EN EXCESO DE XIII MES
   AND PPL_ESTADO = ''Autorizado''
   GROUP BY DSS_CODEMP
) V
GROUP BY CODCIA, CODEMP','CODEMP','TodosExcluyendo',0,0);


commit transaction;

