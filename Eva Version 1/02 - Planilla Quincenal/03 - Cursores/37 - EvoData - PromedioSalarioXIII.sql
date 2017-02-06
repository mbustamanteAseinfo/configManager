/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:38 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PromedioSalarioXIII';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PromedioSalarioXIII','PromedioSalarioXIII','SELECT INN_CODEMP, 
       INN_VALOR AS PROMEDIO_SALARIO, 
       INN_VALOR AS PROMEDIO_GREP, 
       inn_tiempo as INN_DIAS_SALARIO, 
       inn_tiempo AS INN_DIAS_GREP 
FROM sal.inn_ingresos 
WHERE inn_codemp < 1','DECLARE	@CODCIA INT,
        @CODTPL INT,
        @CODPPL INT

SET @CODCIA = $$CODCIA$$
SET @CODTPL = $$CODTPL$$
SET @CODPPL = $$CODPPL$$

SELECT DPX_CODEMP INN_CODEMP,
       DPX_PROM_SALARIO PROMEDIO_SALARIO,
       DPX_PROM_GASTO_REP PROMEDIO_GREP,
       DPX_DIAS_SALARIO INN_DIAS_SALARIO,
       DPX_DIAS_GASTO_REP INN_DIAS_GREP
FROM pa.dpx_datos_prom_xiii 
WHERE dpx_codcia = @CODCIA 
AND dpx_codtpl = @CODTPL 
AND dpx_codppl = @CODPPL','inn_codemp','TodosExcluyendo',0,0);


commit transaction;

