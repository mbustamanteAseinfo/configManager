/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:24 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_Incapacidades';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_Incapacidades','Emp_Incapacidades','SELECT txi_codcia IXE_CODCIA, 
       pie_codppl PIE_CODPLA, 
       IXE_CODTXI, 
       IXE_CODEMP, 
       ixe_codrin IXE_RIESGO, 
       PIE_INICIO, 
       PIE_FINAL, 
       PIE_DIAS, 
       pie_aplicado_planilla,
	   pie_planilla_autorizada, 
       (CASE WHEN PIE_INICIO = IXE_INICIO THEN ''S'' ELSE ''N'' END) PIE_ES_PRIMERA,
       PIE_VALOR_TOTAL, 
       PIE_VALOR_A_PAGAR, 
       PIE_VALOR_A_DESCONTAR, /* pie_valor_total - pie_valor_a_pagar*/
       pie_ajuste_sobre_sal_maximo, 
       pie_horas,
       convert(numeric(12,2), coalesce(pie_valor_a_pagar, 0) / (case coalesce(pie_salario_hora, 0) when 0 then 1 else coalesce(pie_salario_hora, 0) end)) pie_horas_pagar,
       convert(numeric(12,2), coalesce(pie_valor_a_descontar, 0) / (case coalesce(pie_salario_hora, 0) when 0 then 1 else coalesce(pie_salario_hora, 0) end)) pie_horas_descontar,
       convert(bit,(case when ixe_codrin = isnull(gen.get_valor_parametro_int(''PA_CodigoRiesgoMaternidad'',''pa'',null,null,null), 1) then 1 else 0 end)) ixe_es_maternidad
  FROM acc.ixe_incapacidades
  JOIN acc.pie_periodos_incapacidad ON ixe_codigo = pie_codixe
  JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
  where 1 = 2','SELECT txi_codcia IXE_CODCIA, 
       pie_codppl PIE_CODPLA, 
       IXE_CODTXI, 
       IXE_CODEMP, 
       ixe_codrin IXE_RIESGO, 
       PIE_INICIO, 
       PIE_FINAL, 
       PIE_DIAS, 
       pie_aplicado_planilla,
	   pie_planilla_autorizada, 
       (CASE WHEN PIE_INICIO = IXE_INICIO THEN ''S'' ELSE ''N'' END) PIE_ES_PRIMERA,
       PIE_VALOR_TOTAL, 
       PIE_VALOR_A_PAGAR, 
       PIE_VALOR_A_DESCONTAR, /* pie_valor_total - pie_valor_a_pagar*/
       pie_ajuste_sobre_sal_maximo, 
       pie_horas,
       convert(numeric(12,2), coalesce(pie_valor_a_pagar, 0) / (case coalesce(pie_salario_hora, 0) when 0 then 1 else coalesce(pie_salario_hora, 0) end)) pie_horas_pagar,
       convert(numeric(12,2), coalesce(pie_valor_a_descontar, 0) / (case coalesce(pie_salario_hora, 0) when 0 then 1 else coalesce(pie_salario_hora, 0) end)) pie_horas_descontar,
       convert(bit,(case when ixe_codrin = isnull(gen.get_valor_parametro_int(''PA_CodigoRiesgoMaternidad'',''pa'',null,null,null), 1) then 1 else 0 end)) ixe_es_maternidad
FROM acc.ixe_incapacidades
JOIN acc.pie_periodos_incapacidad ON ixe_codigo = pie_codixe
JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
JOIN acc.rin_riesgos_incapacidades on rin_codigo= ixe_codrin
WHERE pie_aplicado_planilla = 0
AND pie_planilla_autorizada = 0
AND (pie_valor_a_pagar > 0 or PIE_VALOR_A_DESCONTAR > 0)
AND txi_codcia = $$CODCIA$$
AND pie_codppl = $$CODPPL$$
AND rin_utiliza_fondo = 1','ixe_codemp','','','TodosExcluyendo',0,0);


commit transaction;

