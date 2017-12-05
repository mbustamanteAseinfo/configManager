/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:33 PM */

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
   and inn_codtig in ( (select tig_codigo from sal.tig_tipos_ingreso where tig_abreviatura = ''Gasto Rep'' and tig_codcia = @codcia) )
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

