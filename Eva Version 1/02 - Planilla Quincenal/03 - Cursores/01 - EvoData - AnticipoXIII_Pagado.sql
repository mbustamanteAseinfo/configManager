/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:13 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'AnticipoXIII_Pagado';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','AnticipoXIII_Pagado','AnticipoXIII_Pagado','SELECT 0 INN_CODCIA, /*INN_CODTPL, INN_CODPLA, */ INN_CODEMP, 0.00 ADELANTO_XIII, 0.00 ADELANTO_XIII_GR
FROM sal.inn_ingresos
WHERE inn_codigo < 0','DECLARE @codcia INT, @codtpl INT, @codppl INT, @fecha_ini DATETIME, @fecha_fin DATETIME
DECLARE @codtpl_anticipo INT, @codtig_anticipoXIII INT, @codtig_anticipoXIII_GR INT

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SET @codtpl_anticipo = 6 -- Planilla de anticipo XIII
SELECT @codtig_anticipoXIII = tig_codigo FROM sal.tig_tipos_ingreso where tig_codcia=@codcia and tig_abreviatura=''ADELANTO_XIII_PA'' -- Ingreso de anticipo XIII
SELECT @codtig_anticipoXIII_GR = tig_codigo FROM sal.tig_tipos_ingreso where tig_codcia=@codcia and tig_abreviatura=''ADELANTO_XIII_GR_PA'' -- Ingreso de anticipo XIII Gasto de Representacion

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND PPL_CODTPL = @codtpl
AND ppl_codigo = @codppl

SELECT tpl_codcia INN_CODCIA, /*INN_CODTPL, INN_CODPLA, */ INN_CODEMP, 
       SUM(CASE INN_CODTIG WHEN @codtig_anticipoXIII THEN INN_VALOR ELSE 0 END) ADELANTO_XIII,
       SUM(CASE INN_CODTIG WHEN @codtig_anticipoXIII_GR THEN INN_VALOR ELSE 0 END) ADELANTO_XIII_GR
FROM sal.inn_ingresos
JOIN sal.ppl_periodos_planilla
ON ppl_codigo = inn_codppl
JOIN sal.tpl_tipo_planilla
ON tpl_codigo = ppl_codtpl
WHERE PPL_CODTPL = @codtpl_anticipo
AND PPL_FECHA_FIN >= @fecha_ini
AND PPL_FECHA_FIN <= @fecha_fin
AND INN_VALOR > 0
AND PPL_ESTADO = ''Autorizado''
GROUP BY tpl_codcia, /*INN_CODTPL, INN_CODPLA,*/ INN_CODEMP
ORDER BY INN_CODCIA, /*INN_CODTPL, INN_CODPLA,*/ INN_CODEMP
','inn_codemp','TodosExcluyendo',0,0);


commit transaction;

