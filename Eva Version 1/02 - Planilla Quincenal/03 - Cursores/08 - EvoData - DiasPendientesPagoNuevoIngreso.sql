/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:14 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'DiasPendientesPagoNuevoIngreso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','DiasPendientesPagoNuevoIngreso','DiasPendientesPagoNuevoIngreso','SELECT 0 EMP_CODCIA, 0 EMP_CODIGO, 0.00 salario_proporcional, 0.00 gasto_rep_proporcional, 0 dias','declare @codcia int, @codtpl int, @fecha_ini datetime, @fecha_fin datetime, @codpla_ult int
set @codcia = $$CODCIA$$
set @codtpl = isnull(gen.get_valor_parametro_varchar(''CodigoPlanillaQuincenal'', null, null, @codcia, null), 1)

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

