/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:14 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DiasPagadosIncapacidad';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DiasPagadosIncapacidad','DiasPagadosIncapacidad','SELECT 0 IXE_CODCIA, 0 IXE_CODEMP, 0 DIAS_PAGADOS','SET DATEFORMAT DMY
SELECT txi_codcia IXE_CODCIA, IXE_CODEMP, COALESCE(SUM(PIE_DIAS), 0) DIAS_PAGADOS
FROM acc.ixe_incapacidades
JOIN acc.pie_periodos_incapacidad ON ixe_codigo = pie_codixe
JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
JOIN acc.rin_riesgos_incapacidades ON rin_codigo= ixe_codrin
WHERE txi_codcia = $$CODCIA$$
AND pie_aplicado_planilla = 1
AND pie_planilla_autorizada = 1
and rin_utiliza_fondo = 1
AND PIE_INICIO >= CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(YY, -2, GETDATE()), 103))
AND pie_valor_a_pagar != 0
GROUP BY txi_codcia, IXE_CODEMP
','IXE_CODEMP','','TodosExcluyendo',0,0);


commit transaction;

