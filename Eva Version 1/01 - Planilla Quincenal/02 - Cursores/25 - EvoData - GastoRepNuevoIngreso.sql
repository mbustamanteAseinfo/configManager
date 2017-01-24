/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:33 PM */

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

