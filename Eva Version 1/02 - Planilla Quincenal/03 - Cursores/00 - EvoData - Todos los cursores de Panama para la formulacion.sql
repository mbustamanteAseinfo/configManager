/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'CuotasIngresosCiclicos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','CuotasIngresosCiclicos','CuotasIngresosCiclicos','select *
from sal.cic_cuotas_ingreso_ciclico
join sal.igc_ingresos_ciclicos
on cic_codigc = igc_codigo
where 1 = 2','select *
from sal.cic_cuotas_ingreso_ciclico
join sal.igc_ingresos_ciclicos
on cic_codigc = igc_codigo
where cic_codppl = $$CODPPL$$
--and sal.empleado_en_gen_planilla(''$$SESSIONID$$'', igc_codemp) = 1
and cic_valor_cuota > 0','','cic_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'CuotasDescuentosCiclicos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_field_codtpl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','CuotasDescuentosCiclicos','CuotasDescuentosCiclicos','select *
from sal.cdc_cuotas_descuento_ciclico
join sal.dcc_descuentos_ciclicos
on cdc_coddcc = dcc_codigo
where 1 = 2','select *
from sal.cdc_cuotas_descuento_ciclico
join sal.dcc_descuentos_ciclicos
on cdc_coddcc = dcc_codigo
where cdc_codppl = $$CODPPL$$
','dcc_codemp','cdc_codppl','dcc_codtpl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Datos_Renta';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Datos_Renta','Datos_Renta','select *
from sal.rap_renta_anual_panama 
where 1  = 0','select *
from sal.rap_renta_anual_panama
where rap_codcia = $$CODCIA$$
and rap_codtpl = $$CODTPL$$
and rap_codppl = $$CODPPL$$
','rap_codemp','rap_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Datos_Renta_Gastos_Rep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Datos_Renta_Gastos_Rep','Datos_Renta_Gastos_Rep','select * from sal.rag_renta_anual_panama_gr where 1 = 2','select * from sal.rag_renta_anual_panama_gr
where rag_codcia = $$CODCIA$$
and rag_codppl = $$CODPPL$$','rag_codemp','rag_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DescuentosEstaPlanilla';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DescuentosEstaPlanilla','Descuentos Aplicados en la Planilla','select * from tmp.dss_descuentos
where dss_codigo < 0','select * 
from tmp.dss_descuentos
where dss_codppl = $$CODPPL$$','','dss_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DiasPendientesPagoNuevoIngreso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DiasPendientesPagoNuevoIngreso','DiasPendientesPagoNuevoIngreso','SELECT 0 EMP_CODCIA, 0 EMP_CODIGO, 0.00 salario_proporcional, 0.00 gasto_rep_proporcional, 0 dias','declare @codcia int, @codtpl int, @fecha_ini datetime, @fecha_fin datetime, @codpla_ult int
set @codcia = $$CODCIA$$
set @codtpl = isnull(gen.get_valor_parametro_varchar(''PA_CodigoPlanillaQuincenal'', null, null, @codcia, null), 1)

-- Periodo de pago de la planilla inmediata anterior
SELECT TOP 1 @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN, @codpla_ult = ppl_codigo
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND PPL_CODTPL = @codtpl
AND PPL_ESTADO = ''Autorizado''
ORDER BY PPL_FECHA_PAGO DESC

-- Empleados que ingresaron en la ultima planilla y que no recibieron pago
SELECT plz_codcia EMP_CODCIA, EMP_CODIGO,
isnull(convert(numeric(12,2), sal.fn_total_horas_laborales_periodo (plz_codcia, emp_codigo, emp_fecha_ingreso, @fecha_fin) * sal.valor_hora), 0) salario_proporcional,
isnull(convert(numeric(12,2), sal.fn_total_horas_laborales_periodo (plz_codcia, emp_codigo, emp_fecha_ingreso, @fecha_fin) * gr.valor_hora), 0) gasto_rep_proporcional,
isnull(datediff(dd, emp_fecha_ingreso, @fecha_fin) + 1 - coalesce(sal.FN_DIAS_DOMINGO(EMP_FECHA_INGRESO,@fecha_fin), 0) - (case when datepart(weekday,@fecha_fin) = 1 then 1 else 0 end), 0) dias
FROM exp.emp_empleos
JOIN eor.plz_plazas on plz_codigo = emp_codplz
join exp.fn_get_datos_rubro_salarial (null, ''S'',@fecha_fin,''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
left join exp.fn_get_datos_rubro_salarial (null, ''G'',@fecha_fin,''pa'') gr on gr.codemp = emp_codigo and gr.codtpl = emp_codtpl
WHERE EMP_ESTADO = ''A''
AND EMP_FECHA_INGRESO >= @fecha_ini
AND EMP_FECHA_INGRESO <= @fecha_fin
AND NOT EXISTS(SELECT * FROM sal.inn_ingresos WHERE inn_codppl = @codpla_ult AND INN_CODEMP = EMP_CODIGO)
AND plz_codcia = @codcia','emp_codigo','plz_codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DiasPSGS';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DiasPSGS','DiasPSGS','SELECT 0 CODCIA, 0 CODEMP, 0 DIAS, 0.00 HORAS','declare @codcia int, @codtpl int, @codppl int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

exec pa.proc_cur_DiasPSGS @codcia, @codtpl, @codppl','codemp','codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_HorasExtras';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_HorasExtras','Emp_HorasExtras','select *
from sal.ext_horas_extras
JOIN sal.the_tipos_hora_extra
on the_codigo = ext_codthe
where the_codcia < 0','select *
from sal.ext_horas_extras
JOIN sal.the_tipos_hora_extra
on the_codigo = ext_codthe
where ext_estado = ''Autorizado''
and ext_ignorar_en_planilla = 0
and ext_codppl = $$CODPPL$$','ext_codemp','ext_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_InfoSalario','Emp_InfoSalario','SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'','''',''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', '''', ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
 WHERE plz_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_fin_ppl datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

set nocount on

SELECT @fecha_fin_ppl = ppl_fecha_fin
FROM sal.ppl_periodos_planilla
WHERE ppl_codigo = @codppl

SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join exp.exp_expedientes on exp_codigo = emp_codexp
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'',@fecha_fin_ppl,''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin_ppl, ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
 WHERE plz_codcia = @codcia
   and ((emp_estado = ''A'') or (emp_estado = ''R''))
   AND ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') = (CASE @codtpl WHEN 5 THEN 
																										ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') 
																									 ELSE ''N'' END)
--   and (isnull(dpl_suspendido, ''''N'''') = ''''N''''
--   and @codtpl = (select case when tpl_aplicacion = ''''N'''' then emp_codtpl else tpl_codigo end
--                    from pla_tpl_tipo_planilla
--                   where tpl_codcia = emp_codcia
--                     and tpl_codigo = @codtpl))
','emp_codigo','TodosExcluyendo',1,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Ajustes';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_InfoSalario_Ajustes','Cursosr principal de la planilla de Ajustes','SELECT emp_codigo,
   emp_estado,
   emp_codplz,
   emp_fecha_ingreso,
   emp_codtco,
   plz_coduni,
   CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida,
   emp_fecha_retiro,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''ClaseRenta''), '''') dpl_codclr,
   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''NumeroDependientes''), 0) dpl_no_dependientes_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''MarcaTarjeta''), cast(0 as bit)) dpl_marca_tarjeta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''esSuspendido''), cast(0 as bit)) dpl_suspendido,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DescuentaRenta''), cast(1 as bit)) dpl_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyugue_renta,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''TipoAplicacionRenta''), ''P'') dpl_tipo_aplicacion_renta,
   ''PAB'' codmon
FROM exp.emp_empleos
join eor.plz_plazas
on plz_codigo = emp_codplz
join exp.esa_est_sal_actual_empleos_v
on esa_codemp = emp_codigo
where 1 = 2
','declare @codcia int, @codppl int, @codpai varchar(2), @fecha_fin_ppl datetime, @codtpl int, @fecha_ini_ppl datetime, @FRECUENCIA INT, @codmon varchar(3)

SET @codcia = $$CODCIA$$
SET @codppl = $$CODPPL$$
SET @codtpl = $$CODTPL$$ 

set nocount on 

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

SELECT @fecha_fin_ppl = ppl_fecha_fin,@fecha_ini_ppl = ppl_fecha_ini, @FRECUENCIA = PPL_FRECUENCIA, @codmon=tpl_codmon
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE ppl_codigo = @codppl

SELECT emp_codigo, 
   emp_estado,
   emp_codplz,
   emp_fecha_ingreso,
   emp_codtco,
   plz_coduni,
   CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida,
   emp_fecha_retiro,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''ClaseRenta''), '''') dpl_codclr,
   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''NumeroDependientes''), 0) dpl_no_dependientes_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''MarcaTarjeta''), cast(0 as bit)) dpl_marca_tarjeta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''esSuspendido''), cast(0 as bit)) dpl_suspendido,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DescuentaRenta''), cast(1 as bit)) dpl_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyugue_renta,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''TipoAplicacionRenta''), ''P'') dpl_tipo_aplicacion_renta,
   @codmon codmon
FROM exp.emp_empleos
join eor.plz_plazas on plz_codigo = emp_codplz
join exp.fn_get_datos_rubro_salarial(NULL, ''S'', @fecha_fin_ppl, @codpai)  sal on sal.codemp = emp_codigo
left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin_ppl, @codpai)  gto on GTO.codemp = emp_codigo
where plz_codcia = @codcia
and (emp_estado = ''A'' or emp_estado = ''R'')
and emp_codtpl = case
					when @codtpl in (select distinct emp_codtpl from exp.emp_empleos where emp_estado = ''A'')
					then @codtpl
					else emp_codtpl
				 end
and exists 
( (select oin_codemp
   from sal.oin_otros_ingresos
  where oin_codppl = @codppl
    and oin_codemp = emp_codigo
    and oin_ignorar_en_planilla = 0
    and oin_estado = ''Autorizado'')
  UNION
  (select ext_codemp
     from sal.ext_horas_extras
    where ext_codppl = @codppl
      and ext_codemp = emp_codigo
      and ext_ignorar_en_planilla = 0
      and ext_estado = ''Autorizado''
   )
)','emp_codigo','TodosExcluyendo',1,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Vacaciones';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_InfoSalario_Vacaciones','Cursor principal de la planilla de Vacaciones','SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join exp.exp_expedientes on exp_codigo = emp_codexp
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'','''',''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', '''', ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
 WHERE plz_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_fin_ppl datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

set nocount on

SELECT @fecha_fin_ppl = ppl_fecha_fin
FROM sal.ppl_periodos_planilla
WHERE ppl_codigo = @codppl

SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join exp.exp_expedientes on exp_codigo = emp_codexp
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'',@fecha_fin_ppl,''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin_ppl, ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
where exists
( select *
    from pa.mpv_montos_pago_vacacion where mpv_codppl = @codppl and mpv_codemp = emp_codigo
) and plz_codcia = @codcia
   and emp_estado = ''A''
   AND ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') = (CASE @codtpl WHEN 5 THEN 
																										ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') 
																									 ELSE ''N'' END)
','emp_codigo','NingunoIncluyendo',1,0);

--Planilla Vacaciones
insert into [sal].[tpc_tipos_planilla_cursor] ([tpc_codfcu],[tpc_codtpl]) select [fcu_codigo], (select tpl_codigo from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon = 'PAB') from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Vacaciones';

commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_OtrosDescuentos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_OtrosDescuentos','Emp_OtrosDescuentos','select *
from sal.ods_otros_descuentos
where 1 = 2','select *
from sal.ods_otros_descuentos
where ods_estado = ''Autorizado''
and ods_ignorar_en_planilla = 0
and ods_codppl = $$CODPPL$$
and not exists (select dag_codtdc 
				from sal.dag_descuentos_agrupador 
				join sal.agr_agrupadores on agr_codigo = dag_codagr
				where dag_codtdc = ods_codtdc
				and agr_abreviatura in (''BaseCalculoSeguroSocial'',''BaseCalculoSeguroEducativo'',
										   ''IngresosRentaPTY'',''IngresosRentaGRepPTY''))','ods_codemp','ods_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_OtrosDescuentos_AplicaLegal';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_OtrosDescuentos_AplicaLegal','Emp_OtrosDescuentos_AplicaLegal','select *
from sal.ods_otros_descuentos
where 1 = 2','select *
from sal.ods_otros_descuentos
where ods_estado = ''Autorizado''
and ods_ignorar_en_planilla = 0
and ods_codppl = $$CODPPL$$
and ( exists (select dag_codtdc 
				from sal.dag_descuentos_agrupador 
				join sal.agr_agrupadores on agr_codigo = dag_codagr
				where dag_codtdc = ods_codtdc
				and agr_abreviatura in (''BaseCalculoSeguroSocial'',''BaseCalculoSeguroEducativo'',
										  ''DescuentosRentaPTY'',''Agrupador Descuentos Renta GRep PTY'') ) )','ods_codemp','ods_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_OtrosIngresos';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_OtrosIngresos','Emp_OtrosIngresos','select *
from sal.oin_otros_ingresos
where oin_codppl < 0','select *
from sal.oin_otros_ingresos
where oin_estado = ''Autorizado''
and oin_ignorar_en_planilla = 0
and oin_codppl = $$CODPPL$$','oin_codemp','oin_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_TmpNoTrabajado';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_TmpNoTrabajado','Emp_TmpNoTrabajado','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnt_codcia < 0','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnn_estado = ''Autorizado''
and tnn_ignorar_en_planilla = 0
and tnn_codppl = $$CODPPL$$
and tnt_codcia = $$CODCIA$$','tnn_codemp','tnn_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_TNT';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_TNT','Tiempos no trabajados','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnt_codcia < 0','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnn_estado = ''Autorizado''
and tnn_ignorar_en_planilla = 0
and tnt_goce_sueldo = 0
and tnt_codtdc = (select tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = ''Tardanza_PA'')
and tnn_codppl = $$CODPPL$$','tnn_codemp','tnn_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_TNT2';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_TNT2','Emp_TNT2','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnt_codcia < 0','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnn_estado = ''Autorizado''
and tnn_ignorar_en_planilla = 0
and tnt_goce_sueldo = 0
and tnt_codtdc = (select tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = ''Ausencias_PA'')
and tnn_codppl = $$CODPPL$$','tnn_codemp','tnn_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_TNT3';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_TNT3','Tiempos no trabajados','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnt_codcia < 0','SELECT	*
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codigo = tnn_codtnt
WHERE tnn_estado = ''Autorizado''
and tnn_ignorar_en_planilla = 0
and tnt_goce_sueldo = 0
and tnt_codtdc = (select tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = ''Ausencias_PA'')
and tnn_codppl = $$CODPPL$$','tnn_codemp','tnn_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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
   WHERE DSS_CODTDC = isnull(gen.get_valor_parametro_int(''PA_CodigoTDCExcesoXIII'',null,null,@codcia,null), 0) -- PAGO EN EXCESO DE XIII MES
   AND PPL_ESTADO = ''Autorizado''
   GROUP BY DSS_CODEMP
) V
GROUP BY CODCIA, CODEMP','CODEMP','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ExcesoXIII_GR';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ExcesoXIII_GR','ExcesoXIII_GR','SELECT 0 CODCIA, 0 CODEMP, 0.00 EXCESO','Declare @codcia int,
		@codppl int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

SELECT CODCIA, CODEMP, SUM(MONTO) EXCESO
FROM (
   /*SELECT DPX_CODCIA CODCIA, DPX_CODEMP CODEMP, SUM(DPX_VALOR) MONTO
   FROM PLA_DPX_DESC_PENDIENTE_XIII_GR
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
   WHERE DSS_CODTDC = isnull(gen.get_valor_parametro_int(''PA_CodigoTDCExcesoXIII_GR'',null,null,@codcia,null), 0) -- PAGO EN EXCESO DE XIII MES GR
   AND PPL_ESTADO = ''Autorizado''
   GROUP BY DSS_CODEMP
) V
GROUP BY CODCIA, CODEMP','CODEMP','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'GastoRepImpar';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','GastoRepImpar','GastoRepImpar','select emp_codigo, exp_codigo_alternativo, ese_valor, ese_valor as dif, ese_valor / 2 as quincena, ese_valor as salario, ese_valor as pago
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
where emp_estado = ''X''','declare @codppl int, @frecuencia int, @anio int, @mes int, @codcia int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

select @frecuencia = ppl_frecuencia, @anio = ppl_anio, @mes = ppl_mes
from sal.ppl_periodos_planilla
where ppl_codigo = @codppl

select *, ese_valor - salario pago
from (
select *, ese_valor / 2 quincena
, (select sum(inn_valor)
   from sal.inn_ingresos 
   join sal.ppl_periodos_planilla
   on ppl_codigo = inn_codppl
   join sal.tpl_tipo_planilla
   on tpl_codigo = ppl_codtpl
   where tpl_codcia = @codcia
   and ppl_anio = @anio
   and ppl_mes = @mes
   and ppl_frecuencia = 2
   and inn_codemp = emp_codigo 
   and inn_codtig in ( (select tig_codigo from sal.tig_tipos_ingreso where tig_abreviatura = ''Gasto Rep_PA'') )
  ) salario
from (
select emp_codigo, exp_codigo_alternativo, exp_nombres_apellidos, ese_valor, convert(numeric(12,2), ese_valor / 2) - ese_valor / 2 dif
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
where emp_estado = ''A''
and ese_codrsa = 2
and ese_estado = ''V''
and @frecuencia = 2
) v
where dif > 0
) w
where isnull(salario, 0) > 0
','emp_codigo','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'GastoRepNuevoIngreso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','GastoRepNuevoIngreso','Gasto de Representacion para personal de NuevoIngreso','select plz_codcia emp_codcia, emp_codigo, 0.0000 salario_proporcional, 0 dias
from exp.emp_empleos
join eor.plz_plazas on plz_codigo = emp_codplz
join exp.fn_get_datos_rubro_salarial(NULL, ''G'', '''', ''pa'') salario ON salario.codemp = emp_codigo
where plz_codcia = 0','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime, @codpai varchar(2)

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

select @fecha_ini = ppl_fecha_ini, @fecha_fin = ppl_fecha_fin
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
where tpl_codcia = @codcia
and ppl_codtpl = @codtpl
and ppl_codigo = @codppl

select plz_codcia emp_codcia, emp_codigo, convert(numeric(12,2), sal.fn_total_horas_laborales_periodo (plz_codcia, emp_codigo, emp_fecha_ingreso, @fecha_fin) * valor_hora) salario_proporcional, 
datediff(dd, emp_fecha_ingreso, @fecha_fin) + 1 - coalesce(sal.FN_DIAS_DOMINGO(EMP_FECHA_INGRESO,@fecha_fin), 0) - (case when datepart(weekday,@fecha_fin) = 1 then 1 else 0 end) dias
from exp.emp_empleos
join eor.plz_plazas on plz_codigo = emp_codplz
join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin, @codpai) salario ON salario.codemp = emp_codigo
where emp_estado = ''A''
and emp_fecha_ingreso > @fecha_ini
and emp_fecha_ingreso <= @fecha_fin
and plz_codcia = @codcia','emp_codigo','emp_codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'IngresosEstaPlanilla';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','IngresosEstaPlanilla','Registro de Ingresos Pagados en Planilla','select * 
  from tmp.inn_ingresos
 where inn_codigo < 0','select * 
  from tmp.inn_ingresos
 where inn_codppl = $$CODPPL$$','inn_codemp','inn_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'MontosPagoVacacion';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','MontosPagoVacacion','Montos para el calculo de pagos de vacacion','select * from pa.mpv_montos_pago_vacacion where mpv_codppl < 0','select * from pa.mpv_montos_pago_vacacion
where mpv_codppl = $$CODPPL$$','mpv_codemp','mpv_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PagoProporcionalIncremento';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PagoProporcionalIncremento','PagoProporcionalIncremento','SELECT 0 INN_CODCIA, 0 DIN_CODEMP, 0.00 HORAS_PREVIO, 0.00 SALARIO_PREVIO, 0.00 HORAS_ACTUAL, 0.00 SALARIO_ACTUAL
WHERE 1 = 2','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND PPL_CODTPL = @codtpl
AND ppl_codigo = @codppl

SELECT DISTINCT tin_codcia INC_CODCIA, inc_codemp DIN_CODEMP,
       sal.fn_total_horas_laborales_periodo(@codcia, inc_codemp, @fecha_ini, DATEADD(DD, -1, idr_fecha_vigencia)) HORAS_PREVIO,
       sal.fn_total_horas_laborales_periodo_salario(@codcia, inc_codemp, @fecha_ini, DATEADD(DD, -1, idr_fecha_vigencia)) SALARIO_PREVIO,
       sal.fn_total_horas_laborales_periodo(@codcia, inc_codemp, idr_fecha_vigencia, @fecha_fin) HORAS_ACTUAL,
       sal.fn_total_horas_laborales_periodo_salario(@codcia, inc_codemp, idr_fecha_vigencia, @fecha_fin) SALARIO_ACTUAL
FROM acc.idr_incremento_detalle_rubros
JOIN acc.inc_incrementos ON inc_codigo = idr_codinc
JOIN acc.tin_tipos_incremento ON tin_codigo = inc_codtin
WHERE idr_fecha_vigencia > @fecha_ini
AND idr_fecha_vigencia <= @fecha_fin
AND INC_ESTADO = ''A''
AND tin_codcia = @codcia','DIN_CODEMP','INN_CODCIA','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'pagos_vacacion_estaquincena';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','pagos_vacacion_estaquincena','pagos_vacacion_estaquincena','select 
    ppl_codtpl dpv_codtpl, ppl_codigo dpv_codpla, vac_codemp dpv_codemp, dva_dias dpv_dias, ''A'' dpv_estado 
from acc.dva_dias_vacacion
join acc.vac_vacaciones ON vac_codigo = dva_codvac
join sal.ppl_periodos_planilla on ppl_codigo = dva_codppl
where ppl_codigo = 0','declare @fini datetime, @ffin datetime, @codppl int

set @codppl = $$CODPPL$$

select @fini = ppl_fecha_ini, @ffin = ppl_fecha_fin
from sal.ppl_periodos_planilla
where ppl_codigo = @codppl

select ppl_codtpl dpv_codtpl, @codppl dpv_codpla, vac_codemp dpv_codemp, dva_dias dpv_dias, ''A'' dpv_estado
from acc.dva_dias_vacacion
join acc.vac_vacaciones
on vac_codigo = dva_codvac
join sal.ppl_periodos_planilla
on ppl_codigo = dva_codppl
where (@fini >= dva_desde and @fini <= dva_hasta)
and (@ffin >= dva_desde and @fini<= dva_hasta)
and dva_pagadas = 0','dpv_codemp','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ParametrosCuotaISSS';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ParametrosCuotaISSS','ParametrosCuotaISSS','SELECT 0.00 pge_isss_por_desc, 
	   0.00 pge_isss_por_desc_pat, 
	   0.00 pge_isss_por_desc_decimo, 
	   0.00 pge_isss_por_desc_pat_decimo,
	   0.00 pge_riesgo_prof_por_desc_pat,
	   0.00 pge_profuturo_pa','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

SELECT gen.get_valor_parametro_float(''PA_CuotaEmpleadoSeguroSocial'', @codpai, null, null, null) pge_isss_por_desc,
       gen.get_valor_parametro_float(''PA_CuotaPatronoSeguroSocial'', @codpai, null, null, null) pge_isss_por_desc_pat,
       gen.get_valor_parametro_float(''PA_CuotaEmpleadoSeguroSocialXIII'', @codpai, null, null, null) pge_isss_por_desc_decimo,
       gen.get_valor_parametro_float(''PA_CuotaPatronoSeguroSocialXIII'', @codpai, null, null, null) pge_isss_por_desc_pat_decimo,
       gen.get_valor_parametro_float(''PA_CuotaPatronoRiesgoProfesional'', @codpai, null, null, null) pge_riesgo_prof_por_desc_pat,
       gen.get_valor_parametro_float(''PA_CuotaPrimaAntiguedad'', @codpai, null, null, null) pge_profuturo_pa
       ','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ParametrosSeguroEducativo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ParametrosSeguroEducativo','ParametrosSeguroEducativo','SELECT 0.00 pge_seg_educativo_por_desc, 0.00 pge_seg_educativo_por_pat','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

SELECT gen.get_valor_parametro_float(''PA_CuotaEmpleadoSeguroEducativo'', @codpai, null, null, null) pge_seg_educativo_por_desc,
       gen.get_valor_parametro_float(''PA_CuotaPatronoSeguroEducativo'', @codpai, null, null, null) pge_seg_educativo_por_pat
','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PermisosSinGoceSueldo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PermisosSinGoceSueldo','PermisosSinGoceSueldo','SELECT tnt_codcia TNN_CODCIA, TNN_CODEMP, TNN_CODTNT, TNN_FECHA_DEL, TNN_FECHA_AL
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
WHERE PPL_CODTPL = @codtpl
AND PPL_CODIGO = @codppl

SELECT tnt_codcia TNN_CODCIA, TNN_CODEMP, TNN_CODTNT, TNN_FECHA_DEL, TNN_FECHA_AL
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia = @codcia
AND TNN_ESTADO = ''A''
AND tnt_goce_sueldo = 0 /* TIPOS DE TIEMPOS NO TRABAJADOS SIN GOCE DE SUELDO */
AND TNN_FECHA_DEL <= @fecha_ini
AND TNN_FECHA_AL >= @fecha_fin
UNION
SELECT txi_codcia IXE_CODCIA, IXE_CODEMP,  0, IXE_INICIO, IXE_FINAL
FROM acc.ixe_incapacidades
JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
JOIN acc.rin_riesgos_incapacidades ON rin_codigo = ixe_codrin
WHERE txi_codcia = @codcia
AND rin_utiliza_fondo = 0 
AND (
   (IXE_INICIO <= @fecha_ini AND IXE_FINAL >= @fecha_fin) OR
   (IXE_INICIO <= @fecha_ini AND (IXE_FINAL >= @fecha_ini AND IXE_FINAL <= @fecha_fin)) OR
   ((IXE_INICIO >= @fecha_ini AND IXE_INICIO <= @fecha_fin) AND (IXE_FINAL >= @fecha_fin))
)/* Maternidad, Riesgo Profesional, Pension por Enfermedad*/','tnn_codemp','tnt_codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Pla_Periodo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codcia],[fcu_field_codppl],[fcu_field_codtpl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Pla_Periodo','Pla_Periodo','select tpl_codcia PPL_CODCIA, PPL_CODTPL, ppl_codigo PPL_CODPPL, 
	   PPL_FECHA_INI, PPL_FECHA_FIN, PPL_FECHA_PAGO, 
	   PPL_ESTADO, PPL_FRECUENCIA, ppl_mes PPL_MES_CONT, 
	   ppl_anio ppl_anio_cont, TPL_CODIGO, TPL_DESCRIPCION,
	   TPL_APLICACION, TPL_TOTAL_PERIODOS
	from sal.ppl_periodos_planilla 
	join sal.tpl_tipo_planilla on ppl_codtpl = tpl_codigo
	where tpl_codcia < 0','select tpl_codcia PPL_CODCIA, PPL_CODTPL, ppl_codigo PPL_CODPPL, 
	   PPL_FECHA_INI, PPL_FECHA_FIN, PPL_FECHA_PAGO, 
	   PPL_ESTADO, PPL_FRECUENCIA, ppl_mes PPL_MES_CONT, 
	   ppl_anio ppl_anio_cont, TPL_CODIGO, TPL_DESCRIPCION,
	   TPL_APLICACION, TPL_TOTAL_PERIODOS
	from sal.ppl_periodos_planilla 
	join sal.tpl_tipo_planilla on ppl_codtpl = tpl_codigo
	where tpl_codcia = $$CODCIA$$
    and ppl_codtpl = $$CODTPL$$
	and ppl_codigo = $$CODPPL$$','tpl_codcia','ppl_codppl','tpl_codigo','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PromedioSalarioParaVacaciones';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PromedioSalarioParaVacaciones','PromedioSalarioParaVacaciones','SELECT INN_CODEMP, INN_VALOR AS PROMEDIO, inn_tiempo AS INN_DIAS FROM sal.inn_ingresos WHERE inn_codigo < 1','declare @ult_fecha_pago datetime,
		@agr_ingresos int,
		@codcia int,
		@codtpl_quincenal int,
		@codtpl_vacacion int

select @codcia = $$CODCIA$$

select @codtpl_quincenal = isnull(gen.get_valor_parametro_int(''PA_CodigoPlanillaQuincenal'', null, null, @codcia, null), 1)
select @codtpl_vacacion = isnull(gen.get_valor_parametro_int(''PA_CodigoPlanillaVacacion'', null, null, @codcia, null), 1)

-- Agrupador que contiene los ingresos utilizados para calcular el promedio
select @agr_ingresos = agr_codigo from sal.agr_agrupadores where agr_codpai = ''pa'' and agr_abreviatura = ''IngresosVacacion'' -- Agrupador ingresos calculo de vacacion

-- Fecha de pago de la ultima planilla autorizada
select @ult_fecha_pago = max(ppl_fecha_pago)
from sal.ppl_periodos_planilla
where PPL_ESTADO = ''Autorizado''
AND PPL_CODTPL = @codtpl_quincenal
and PPL_FECHA_PAGO <= (SELECT MIN(V.PPL_FECHA_PAGO) FROM sal.ppl_periodos_planilla V WHERE V.PPL_CODTPL = @codtpl_vacacion AND V.PPL_ESTADO = ''Generado'')

if day(@ult_fecha_pago) > 15
begin 
   set @ult_fecha_pago = gen.fn_last_day(@ult_fecha_pago)
end
else
begin
   set @ult_fecha_pago = gen.fn_last_day(@ult_fecha_pago)
   set @ult_fecha_pago = dateadd(day,-16,@ult_fecha_pago)
end

select INN_CODEMP, round(SUM(isnull(INN_VALOR,0.00))/11,2) as PROMEDIO,SUM(ISNULL(inn_tiempo,0)) as INN_DIAS
from sal.inn_ingresos
join sal.ppl_periodos_planilla on ppl_codigo = inn_codppl
join exp.emp_empleos on EMP_CODIGO = INN_CODEMP
join eor.plz_plazas on plz_codigo = emp_codplz
where plz_codcia = @codcia
and PPL_FECHA_PAGO <= @ult_fecha_pago
and PPL_FECHA_PAGO >= dateadd(mm, -11, @ult_fecha_pago)
and PPL_ESTADO = ''Autorizado''
and inn_codtig in (select iag_codtig from sal.iag_ingresos_agrupador
						join sal.tig_tipos_ingreso on tig_codigo = iag_codtig
						where iag_codagr = @agr_ingresos
						and tig_codcia = @CODCIA)
group by INN_CODEMP
order by INN_CODEMP
','inn_codemp','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RentaAdelantoXIII';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RentaAdelantoXIII','RentaAdelantoXIII','SELECT 0 CODEMP, 0.00 VALOR','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime, @codtdc_renta int, @codtpl_adelanto_xiii int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

select @codtdc_renta = gen.get_valor_parametro_int(''PA_Liq_codtdc_renta'',null,null,@codcia,null)
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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RentaAdelantoXIIIGR';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RentaAdelantoXIIIGR','RentaAdelantoXIIIGR','SELECT 0 CODEMP, 0.00 VALOR','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime, @codtdc_renta int, @codtpl_adelanto_xiii int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

select @codtdc_renta = gen.get_valor_parametro_int(''PA_Liq_codtdc_rentaGastosRep'',null,null,@codcia,null)
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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RentaFija';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RentaFija','RentaFija','select 0 emp_codigo, 0.00 renta_anual, 0.00 renta_periodo, 0.00 sal_anual, 0.00 sal_mensual','declare @codcia int, @codppl int, @codpai varchar(2), @fecha datetime, @incluir_decimo varchar(1), @num_meses real

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

select @num_meses = gen.get_valor_parametro_varchar(''PA_ISRNumeroMeses'', ''pa'', null, null, null) + 1

SELECT @fecha = ppl_fecha_fin
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla
ON tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND ppl_codigo = @codppl

SELECT emp_codigo, sal.fn_get_renta_anual(plz_codcia, valor) renta_anual, sal.fn_get_renta_periodo(plz_codcia, valor) renta_periodo, valor * @num_meses sal_anual, valor sal_mensual
FROM exp.emp_empleos
JOIN eor.plz_plazas
ON plz_codigo = emp_codplz
JOIN exp.fn_get_datos_rubro_salarial(null, ''S'', @fecha, @codpai)
ON codemp = emp_codigo
WHERE plz_codcia = @codcia
AND sal.fn_get_renta_periodo(plz_codcia, valor) > 0.00
','emp_codigo','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ReservasEstaPlanilla';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ReservasEstaPlanilla','Tabla que almacena las reservas de esta planilla','select * 
from tmp.res_reservas
where res_codppl  = -1','select * 
from tmp.res_reservas
where res_codppl = $$CODPPL$$','res_codemp','res_codppl','TodosExcluyendo',0,1);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RetroactivoSalario';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RetroactivoSalario','RetroactivoSalario','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODIGO < 0','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODPPL = $$CODPPL$$
AND PIR_CODRSA = gen.get_valor_parametro_int(''PA_CodigoRubroSalario'', ''pa'', null, null, null)','PIR_CODEMP','PIR_CODPPL','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RetroGastoRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RetroGastoRep','RetroGastoRep','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODIGO < 0','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODPPL = $$CODPPL$$
AND PIR_CODRSA = gen.get_valor_parametro_int(''PA_CodigoRubroGastoRep'', ''pa'', null, null, null)','PIR_CODEMP','PIR_CODPPL','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'SalarioImpar';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','SalarioImpar','SalarioImpar','select emp_codigo, exp_codigo_alternativo, ese_valor, ese_valor as dif, ese_valor / 2 as quincena, ese_valor as salario, ese_valor as pago
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
where emp_estado = ''X''','declare @codppl int, @frecuencia int, @anio int, @mes int, @codcia int

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

select @frecuencia = ppl_frecuencia, @anio = ppl_anio, @mes = ppl_mes
from sal.ppl_periodos_planilla
where ppl_codigo = @codppl

select *, ese_valor - salario pago
from (
select *, ese_valor / 2 quincena
, (select sum(inn_valor)
   from sal.inn_ingresos 
   join sal.ppl_periodos_planilla
   on ppl_codigo = inn_codppl
   join sal.tpl_tipo_planilla
   on tpl_codigo = ppl_codtpl
   where tpl_codcia = @codcia
   and ppl_anio = @anio
   and ppl_mes = @mes
   and ppl_frecuencia = 1
   and inn_codemp = emp_codigo 
   and inn_codtig in ( (select tig_codigo from sal.tig_tipos_ingreso where tig_abreviatura = ''Salario_PA'' or tig_abreviatura = ''Certificado Medico_PA''))
  ) salario
from (
select emp_codigo, exp_codigo_alternativo, exp_nombres_apellidos, ese_valor, convert(numeric(12,2), ese_valor / 2) - ese_valor / 2 dif
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
where emp_estado = ''A''
and ese_codrsa = 1
and ese_estado = ''V''
and @frecuencia = 2
) v
where dif > 0
) w
where isnull(salario, 0) > 0
','emp_codigo','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'SalarioNuevoIngreso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','SalarioNuevoIngreso','SalarioNuevoIngreso','select cia_codigo emp_codcia, cia_codigo emp_codigo, 0 dias, 0.00 horas, 0.0000 salario_proporcional
from eor.cia_companias
where cia_codigo = 0','declare @codcia int, @codtpl int, @codppl int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

exec pa.proc_cur_SalarioNuevoIngreso @codcia, @codtpl, @codppl','emp_codigo','emp_codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'TablaISR';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','TablaISR','TablaISR','select 0.00 isr_desde, 0.00 isr_hasta, 0.00 isr_pct, 0.00 isr_excendente, 0.00 isr_valor','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select inicio isr_desde, fin isr_hasta, porcentaje isr_pct, excedente isr_excedente, valor isr_valor
from gen.get_valor_rango_parametro(''PA_TablaRentaMensual'', @codpai, null, null, null, null)
','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'TablaISR_GRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','TablaISR_GRep','TablaISR_GRep','select 0.00 isr_desde, 0.00 isr_hasta, 0.00 isr_pct, 0.00 isr_excendente, 0.00 isr_valor','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

select inicio isr_desde, fin isr_hasta, porcentaje isr_pct, excedente isr_excedente, valor isr_valor
from gen.get_valor_rango_parametro(''PA_TablaRentaMensualGastoRep'', @codpai, null, null, null, null)
','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'TNT_Extenso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','TNT_Extenso','TNT_Extenso','SELECT *
FROM sal.tnn_tiempos_no_trabajados
JOIN sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
WHERE PPL_CODTPL = @codtpl
AND PPL_CODIGO = @codppl

SELECT *
FROM sal.tnn_tiempos_no_trabajados
JOIN sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia = @codcia
AND (@fecha_ini >= TNN_FECHA_DEL AND @fecha_ini <= TNN_FECHA_AL)
AND (@fecha_fin >= TNN_FECHA_DEL AND @fecha_fin <= TNN_FECHA_AL)','tnn_codemp','tnt_codcia','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'VacacionesEnCurso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','VacacionesEnCurso','VacacionesEnCurso','SELECT vac_codemp CODEMP, dva_codppl CODPLA, DVA_DESDE DESDE, DVA_HASTA HASTA, DVA_DIAS DIAS
FROM acc.dva_dias_vacacion
JOIN acc.vac_vacaciones on vac_codigo = dva_codvac
WHERE vac_codigo < 0','declare @codcia int, @codtpl int, @codppl int, @ppl_fecha_ini datetime, @ppl_fecha_fin datetime, @ppl_mes int, @ppl_fecha_pago datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

select @ppl_fecha_ini = ppl_fecha_ini, @ppl_fecha_fin = ppl_fecha_fin, @ppl_mes = ppl_mes, @ppl_fecha_pago = ppl_fecha_pago
from sal.ppl_periodos_planilla
where ppl_codtpl = @codtpl
and ppl_codigo = @codppl

SELECT CODEMP, CODPLA, DESDE, HASTA
FROM (
	SELECT vac_codemp CODEMP, dva_codppl CODPLA, MIN(DVA_DESDE) DESDE, MAX(DVA_HASTA) HASTA, SUM(DVA_DIAS) DIAS
	FROM acc.dva_dias_vacacion
	JOIN acc.vac_vacaciones on vac_codigo = dva_codvac
	WHERE COALESCE(gen.get_pb_field_data(dva_property_bag_data,''TipoVacacion''), ''T'') <> ''R''
	AND COALESCE(dva_codppl, 0) <> 0
	GROUP BY vac_codemp, dva_codppl
) V
WHERE DIAS >= 30
and ((DESDE >= @ppl_fecha_ini and DESDE <= @ppl_fecha_fin)
or (HASTA >= @ppl_fecha_ini and HASTA <= @ppl_fecha_fin)
or (@ppl_fecha_ini >= DESDE AND @ppl_fecha_fin <= HASTA AND @ppl_fecha_fin >= DESDE AND @ppl_fecha_fin <= HASTA))
and ((case when @ppl_mes = 3 then (case when day(desde) = 1 and month(desde) = 2 then 0 else 1 end) else 1 end)) = 1
and HASTA >= @ppl_fecha_pago','codemp','TodosExcluyendo',0,0);


commit transaction;

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:56 AM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'VacacionesRenunciadas';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','VacacionesRenunciadas','VacacionesRenunciadas','select vac_codemp, isnull(sum(dva_dias), 0.00) dva_dias
from acc.dva_dias_vacacion
join acc.vac_vacaciones on vac_codigo = dva_codvac
left join pa.dpv_dias_pago_vacacion on dpv_codvac = vac_codigo and dpv_coddva = dva_codigo 
where dva_codppl < 0
and dva_pagadas = 1
group by vac_codemp','declare @codppl int, @codtpl int, @codcia int, @fecha_ini datetime, @fecha_fin datetime, @codtpl_vacacion int, @codppl_vacacion int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SET @CODTPL_VACACION = gen.get_valor_parametro_int(''PA_CodigoPlanillaVacacion'', null, null, @CODCIA, null)

if @codtpl = @CODTPL_VACACION 
   set  @codppl_vacacion =  @codppl
ELSE 
BEGIN
	SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
	FROM sal.ppl_periodos_planilla
	JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	WHERE ppl_codigo = @codppl

	/*OBTENGO EL CODIGO DE PLANILLA DE VACACIONES EN ESTADO GENERADO*/
	select @codppl_vacacion = ppl_codigo
	FROM sal.ppl_periodos_planilla
	join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	WHERE tpl_codcia = @codcia
	AND tpl_codigo = @CODTPL_VACACION -- Tipo de planilla Vacaciones
	AND PPL_FECHA_INI >= @FECHA_INI
	AND PPL_FECHA_FIN <= @FECHA_FIN
END

/*OBTENGO LOS DIAS QUE FUERON RENUNCIADOS*/
select vac_codemp, isnull(sum(dpv_dias), 0.00) dva_dias
from pa.dpv_dias_pago_vacacion
join acc.vac_vacaciones on vac_codigo = dpv_codvac
join acc.dva_dias_vacacion on dva_codigo = dpv_coddva
where dpv_codppl = @codppl_vacacion
and dva_pagadas = 1
group by vac_codemp','vac_codemp','TodosExcluyendo',0,0);


commit transaction;

