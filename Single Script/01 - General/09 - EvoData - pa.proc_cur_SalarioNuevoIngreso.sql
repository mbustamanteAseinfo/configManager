IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.proc_cur_SalarioNuevoIngreso')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE [pa].[proc_cur_SalarioNuevoIngreso]
GO
create procedure [pa].[proc_cur_SalarioNuevoIngreso]
	@codcia int, @codtpl int, @codppl int
as
begin

set language english

declare @fecha_ini datetime, @fecha_fin datetime, @codpai varchar(2)

select @fecha_ini = ppl_fecha_ini, @fecha_fin = ppl_fecha_fin, @codpai = cia_codpai
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
join eor.cia_companias on cia_codigo = tpl_codcia
where tpl_codcia = @codcia
and ppl_codtpl = @codtpl
and ppl_codigo = @codppl

select emp_codcia, emp_codigo, dias, horas, convert(numeric(12,2), horas * valor_hora) salario_proporcional
from (
	select plz_codcia emp_codcia,
		   emp_codigo,
		   valor_hora,
		   --convert(numeric(12,2), sal.fn_total_horas_laborales_periodo (plz_codcia, emp_codigo, emp_fecha_ingreso, @fecha_fin) * valor_hora) salario_proporcional, 
		   datediff(dd, emp_fecha_ingreso, @fecha_fin)
				+ 1
				- coalesce(sal.FN_DIAS_DOMINGO(EMP_FECHA_INGRESO,@fecha_fin), 0) 
				- (case when datepart(weekday,@fecha_fin) = 1 then 1 else 0 end)
			dias,
		   sal.fn_total_horas_laborales_periodo(@codcia, emp_codigo, emp_fecha_ingreso, @fecha_fin) horas
	from exp.emp_empleos
	join eor.plz_plazas on plz_codigo = emp_codplz
	join exp.fn_get_datos_rubro_salarial(NULL, 'S', @fecha_fin, @codpai) salario ON salario.codemp = emp_codigo
	where emp_estado = 'A'
	and emp_fecha_ingreso > @fecha_ini
	and emp_fecha_ingreso <= @fecha_fin
	and plz_codcia = @codcia
) v

end

GO
