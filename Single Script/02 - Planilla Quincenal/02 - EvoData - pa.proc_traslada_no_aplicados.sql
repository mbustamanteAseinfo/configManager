IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.proc_traslada_no_aplicados')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_genera_partida_contable]    Script Date: 16-01-2017 2:18:17 PM ******/
DROP PROCEDURE [pa].[proc_traslada_no_aplicados]
GO
CREATE procedure [pa].[proc_traslada_no_aplicados]
	@codppl int
as
begin

declare @ultima_codppl int, @codtpl_quincenal int, @codcia int

select @codcia = tpl_codcia
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
where ppl_codigo = @codppl

select @codtpl_quincenal = gen.get_valor_parametro_int('CodigoPlanillaQuincenal', null, null, @codcia, null)

-- Toma el ultimo periodo de planilla
select @ultima_codppl = ppl_codigo
from sal.ppl_periodos_planilla
where ppl_estado = 'Autorizado'
and ppl_codigo <> @codppl
and ppl_codtpl = @codtpl_quincenal
order by ppl_fecha_pago

--select @ultima_codppl

-- Traslada los ingresos eventuales no aplicados
update sal.oin_otros_ingresos
set oin_codppl = @codppl
where oin_codppl = @ultima_codppl
and oin_aplicado_planilla = 0
and oin_estado = 'Autorizado'
and exists (
	select 1
	from exp.emp_empleos
	where emp_estado = 'A'
	and emp_codigo = oin_codemp
)

-- Traslada los descuentos eventuales no aplicados
update sal.ods_otros_descuentos
set ods_codppl = @codppl
where ods_codppl = @ultima_codppl
and ods_aplicado_planilla = 0
and ods_estado = 'Autorizado'
and exists (
	select 1
	from exp.emp_empleos
	where emp_estado = 'A'
	and emp_codigo = ods_codemp
)

-- Traslada los sobretiempos no aplicados
update sal.ext_horas_extras
set ext_codppl = @codppl
where ext_codppl = @ultima_codppl
and ext_aplicado_planilla = 0
and ext_estado = 'Autorizado'
and exists (
	select 1
	from exp.emp_empleos
	where emp_estado = 'A'
	and emp_codigo = ext_codemp
)

-- Traslada los TNT sin goce de sueldo no aplicados
update sal.tnn_tiempos_no_trabajados
set tnn_codppl = @codppl
where tnn_codppl = @ultima_codppl
and tnn_aplicado_planilla = 0
and tnn_estado = 'Autorizado'
and not exists (
	select 1
	from sal.tnt_tipos_tiempo_no_trabajado
	where tnt_goce_sueldo = 1
	and tnt_codigo = tnn_codtnt
)
and exists (
	select 1
	from exp.emp_empleos
	where emp_estado = 'A'
	and emp_codigo = tnn_codemp
)

end

