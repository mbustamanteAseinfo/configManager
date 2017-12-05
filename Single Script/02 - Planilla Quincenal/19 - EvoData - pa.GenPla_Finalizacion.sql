IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Finalizacion')
                    AND type IN ( N'P', N'PC' ) )


/****** Object:  StoredProcedure [pa].[GenPla_Finalizacion]    Script Date: 16-01-2017 1:43:08 PM ******/
DROP PROCEDURE [pa].[GenPla_Finalizacion]
GO
IF NOT EXISTS ( SELECT  *
            FROM    INFORMATION_SCHEMA.COLUMNS
            WHERE   COLUMN_NAME in ('hpa_codcco', 'hpa_nombre_centro_costo', 'hpa_cco_nomenclatura_contable') )
alter table sal.hpa_hist_periodos_planilla add hpa_codcco int null, hpa_nombre_centro_costo varchar(100) null, hpa_cco_nomenclatura_contable varchar(20) null;

GO
/****** Object:  StoredProcedure [pa].[GenPla_Finalizacion]    Script Date: 16-01-2017 1:43:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Finalizacion]
	@sessionId UNIQUEIDENTIFIER = NULL,
	@codppl INT,
	@userName VARCHAR(100) = NULL
AS
BEGIN

set nocount on

declare @codcia int, @anio int, @mes int, @codtpl int, @fecha_fin datetime

select @codcia = tpl_codcia, @anio = ppl_anio, @mes = ppl_mes, @codtpl = ppl_codtpl, @fecha_fin = ppl_fecha_fin
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
where ppl_codigo = @codppl

declare @now datetime, @maxId bigint
set @now = getdate()

--* Verifica los parámetros
set @userName = isnull(@userName, system_user)

begin transaction

-- Inserta los ingresos generados en la formulacion
insert into sal.inn_ingresos
		(inn_codppl, inn_codemp, inn_codtig, inn_codmon, inn_unidad_tiempo, inn_usuario_grabacion, inn_fecha_grabacion, 
		inn_valor, inn_tiempo)
select inn_codppl, inn_codemp, inn_codtig, inn_codmon, inn_unidad_tiempo, @userName, @now, 
		sum(round(isnull(inn_valor, 0), 2)), sum(round(isnull(inn_tiempo, 0), 2))
from tmp.inn_ingresos
where inn_codppl = @codppl
and sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
and exists (select 1 from sal.tig_tipos_ingreso where tig_codigo = inn_codtig)
group by inn_codppl, inn_codemp, inn_codtig, inn_codmon, inn_unidad_tiempo

-- Inserta los descuentos generados en la formulacion
insert into sal.dss_descuentos
		(dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo, dss_usuario_grabacion, dss_fecha_grabacion, 
		dss_valor, dss_valor_patronal, dss_ingreso_afecto, dss_tiempo)
select dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo, @userName, @now, 
	    sum(round(isnull(dss_valor, 0), 2)), sum(round(isnull(dss_valor_patronal, 0), 2)), 
		sum(round(isnull(dss_ingreso_afecto, 0), 2)), sum(round(isnull(dss_tiempo, 0), 2))
from tmp.dss_descuentos
where dss_codppl = @codppl
and sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
and exists (select 1 from sal.tdc_tipos_descuento where tdc_codigo = dss_codtdc)
-- No consolida los descuentos que corresponden a descuentos ciclicos
and not exists (
	select 1
	from sal.cdc_cuotas_descuento_ciclico 
	join sal.dcc_descuentos_ciclicos 
	on dcc_codigo = cdc_coddcc 
	where cdc_codppl = dss_codppl 
	and dcc_codtdc = dss_codtdc
	and dcc_codemp = dss_codemp
	and cdc_valor_cobrado = dss_valor
	and dcc_activo = 1
)
group by dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo

-- Inserta los descuentos generados en la formulacion
insert into sal.dss_descuentos
		(dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo, dss_usuario_grabacion, dss_fecha_grabacion, 
		dss_valor, dss_valor_patronal, dss_ingreso_afecto, dss_tiempo)
select dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo, @userName, @now, 
	    round(isnull(dss_valor, 0), 2), round(isnull(dss_valor_patronal, 0), 2), 
		round(isnull(dss_ingreso_afecto, 0), 2), round(isnull(dss_tiempo, 0), 2)
from tmp.dss_descuentos
where dss_codppl = @codppl
and sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
and exists (select 1 from sal.tdc_tipos_descuento where tdc_codigo = dss_codtdc)
-- No consolida los descuentos que corresponden a descuentos ciclicos
and exists (
	select 1
	from sal.cdc_cuotas_descuento_ciclico 
	join sal.dcc_descuentos_ciclicos 
	on dcc_codigo = cdc_coddcc 
	where cdc_codppl = dss_codppl 
	and dcc_codtdc = dss_codtdc
	and dcc_codemp = dss_codemp
	and cdc_valor_cobrado = dss_valor
	and dcc_activo = 1
)
	
-- Borra los datos de ingresos las tablas temporales
delete from tmp.inn_ingresos
where inn_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1

-- Borra los datos de descuentos las tablas temporales
delete from tmp.dss_descuentos
where dss_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1

-- Borra los descuentos mayores a cero para los que no existan ingresos en la misma planilla
delete from sal.dss_descuentos 
where dss_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
and dss_valor > 0
and not exists (select 1 from sal.inn_ingresos
				where inn_codppl = dss_codppl
				and inn_codemp = dss_codemp	)

-- Borra los registros de calculo de acumuladores de renta para empleados que no tuvieron ingresos en la planilla
delete from sal.rap_renta_anual_panama
where rap_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, rap_codemp) = 1
and not exists (select 1 from sal.inn_ingresos
				where inn_codppl = rap_codppl
				and inn_codemp = rap_codemp)

-- Elimina las cuotas de descuentos ciclicos que no fueron aplicados en planilla
DELETE FROM sal.cdc_cuotas_descuento_ciclico
WHERE cdc_codppl = @codppl
AND cdc_aplicado_planilla = 0
--and (SELECT sal.empleado_en_gen_planilla(@sessionId, dcc_codemp) 
--     FROM sal.dcc_descuentos_ciclicos
--     WHERE dcc_codigo = cdc_coddcc
--) = 1

-- Elimina las cuotas de descuentos ciclicos del personal que no participa en planilla
delete
from sal.cdc_cuotas_descuento_ciclico
where cdc_codppl = @codppl
and not exists (
	--select 1
	--from sal.dcc_descuentos_ciclicos
	--where dcc_codigo = cdc_coddcc
	--and dcc_codemp in (
	--	select distinct emp_codigo
	--	from exp.emp_empleos
	--	join sal.inn_ingresos
	--	on inn_codemp = emp_codigo
	--	where inn_codppl = 1014
	--)
	select 1
	from sal.inn_ingresos
	join sal.dcc_descuentos_ciclicos
	on dcc_codemp = inn_codemp
	where inn_codppl = cdc_codppl
	and dcc_codigo = cdc_coddcc
	and inn_codppl = @codppl
)

-- Guarda el saldo anterior y saldo nuevo por aplicar la cuota en planilla
update sal.cdc_cuotas_descuento_ciclico
set cdc_property_bag_data = gen.set_pb_field_data(cdc_property_bag_data, 
													'CuotasDescuentoCiclico', 
													'cdc_saldo_anterior', 
													(case dcc_usa_porcentaje
														when 1 then gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_saldo_impar') 
														else dcc_saldo
														end))
from sal.dcc_descuentos_ciclicos
where dcc_codigo = cdc_coddcc
and cdc_codppl = @codppl
and ( dcc_monto_indefinido = 0 or 
		(dcc_usa_porcentaje = 1 and 
		isnull(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_saldo_impar'), 0) > 0)
	)

update sal.cdc_cuotas_descuento_ciclico
set cdc_property_bag_data = gen.set_pb_field_data(cdc_property_bag_data, 
													'CuotasDescuentoCiclico', 
													'cdc_saldo_nuevo', 
													gen.get_pb_field_data_float(cdc_property_bag_data, 'cdc_saldo_anterior') - cdc_valor_cobrado
													)
from sal.dcc_descuentos_ciclicos
where dcc_codigo = cdc_coddcc
and cdc_codppl = @codppl
and ( dcc_monto_indefinido = 0 or 
		(dcc_usa_porcentaje = 1 and 
		isnull(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_saldo_impar'), 0) > 0)
	)

-- Establece como no aplicados los ingresos eventuales de los empleados que no participan en planilla
update sal.oin_otros_ingresos
set oin_aplicado_planilla = 0
where oin_codppl = @codppl
and not exists (
	select 1
	from sal.inn_ingresos
	where inn_codppl = oin_codppl
	and inn_codemp = oin_codemp
)

-- Establece como no aplicados los descuentos eventuales de los empleados que no participan en planilla
update sal.ods_otros_descuentos
set ods_aplicado_planilla = 0
where ods_codppl = @codppl
and not exists (
	select 1
	from sal.dss_descuentos
	where dss_codppl = ods_codppl
	and dss_codemp = ods_codemp
)

update sal.ext_horas_extras
set ext_aplicado_planilla = 0
where ext_codppl = @codppl
and not exists (
	select 1
	from sal.inn_ingresos
	where inn_codppl = ext_codppl
	and inn_codemp = ext_codemp
)

update sal.tnn_tiempos_no_trabajados
set tnn_aplicado_planilla = 0
where tnn_codppl = @codppl
and not exists (
	select 1
	from sal.inn_ingresos
	where inn_codppl = tnn_codppl
	and inn_codemp = tnn_codemp
)
-- Genera la tabla de historicos
-- HISTORICO DE PLANILLAS CALCULADAS
insert into sal.hpa_hist_periodos_planilla
	(hpa_codppl, hpa_codemp, hpa_nombres_apellidos, hpa_apellidos_nombres, hpa_fecha_ingreso, 
	hpa_codafp, hpa_nombre_afp, hpa_codmon, hpa_tasa_cambio, hpa_salario, hpa_salario_hora, 
	hpa_codtco, hpa_codplz, hpa_nombre_plaza, hpa_coduni, hpa_nombre_unidad, hpa_codarf, hpa_nombre_areafun, 
	hpa_codcdt, hpa_nombre_centro_trabajo, hpa_codpue, hpa_nombre_puesto, hpa_nombre_tipo_planilla, hpa_nombre_periodo_planilla, 
	hpa_session_id, hpa_usuario_grabacion, hpa_fecha_grabacion,
	hpa_codcco, hpa_nombre_centro_costo, hpa_cco_nomenclatura_contable
	/*hpa_codjor,hpa_jornada,hpa_horas_x_semana,hpa_rata*/
	)
select @codppl, emp_codigo, exp_nombres_apellidos, exp_apellidos_nombres, emp_fecha_ingreso, 
		null afp_codigo, null afp_nombre, inn_codmon, gen.get_tasa_cambio(inn_codmon, ppl_fecha_fin), isnull(valor, 0), isnull(valor_hora, 0),
		tco_codigo, plz_codigo, plz_nombre, uni_codigo, uni_descripcion, arf_codigo, arf_nombre,
		cdt_codigo, cdt_descripcion, pue_codigo, pue_nombre, tpl_descripcion, left(convert(varchar, ppl_fecha_ini, 100), 11) + ' - ' + left(convert(varchar, ppl_fecha_fin, 100), 11),
		@sessionId, @userName, @now
		, codcco, cco_descripcion, cco_nomenclatura_contable
		/* jor_Codigo, jor_descripcion, jor_total_horas,  case when isnull(jor_total_horas,0) > 0 
															then (isnull(esa_valor, 0) / (52/12.000000)) / jor_total_horas
															else 0
														end */
	from exp.emp_empleos
	join (select inn_codemp, max(inn_codmon) inn_codmon
			from sal.inn_ingresos 
			where inn_codppl = @codppl 
			--and sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
			group by inn_codemp) inn on inn_codemp = emp_codigo
	join sal.ppl_periodos_planilla on ppl_codigo = @codppl
	join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	--left join exp.esa_est_sal_actual_empleos_v on esa_codemp = emp_codigo and esa_es_salario_base = 1
	left join exp.fn_get_datos_rubro_salarial(null, 'S', @fecha_fin, 'pa')
	on codemp = emp_codigo
	join exp.tco_tipos_de_contrato on tco_codigo = emp_codtco
	join eor.plz_plazas on plz_codigo = emp_codplz
	join eor.uni_unidades on uni_codigo = plz_coduni
	join eor.arf_areas_funcionales on arf_codigo = uni_codarf
	join eor.cdt_centros_de_trabajo on cdt_codigo = plz_codcdt
	join eor.pue_puestos on pue_codigo = plz_codpue
	join exp.exp_expedientes on exp_codigo = emp_codexp
	left join sal.jor_jornadas on jor_codigo = emp_codjor
	left join (
		select codplz, codcco, cco_descripcion, cco_nomenclatura_contable
		from (
			select cpp_codplz codplz, max(cpp_codcco) codcco
			from eor.cpp_centros_costo_plaza
			group by cpp_codplz
		) v
		join eor.cco_centros_de_costo
		on cco_codigo = codcco
	) w
	on w.codplz = plz_codigo
	--left join exp.afp_afp on afp_codigo = gen.get_pb_field_data_int(emp_property_bag_data, 'codAFP')

/*****EVALUAR SI VA
-- Borra los ingresos generados con montos cero
delete from sal.inn_ingresos
where inn_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
and inn_valor = 0

-- Borra los descuentos generados con montos cero
delete from sal.dss_descuentos
where dss_codppl = @codppl
--and sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
and dss_valor = 0
*/

--*GENERA HISTORICO DE CENTROS DE COSTO  
delete from  sal.hco_hist_cco_periodos_planilla    
where exists(select null from sal.hpa_hist_periodos_planilla  
				where hpa_Codppl = @codppl and hpa_codigo = hco_codhpa)  
     
INSERT INTO sal.hco_hist_cco_periodos_planilla 
(hco_codhpa, hco_codcco, hco_nombre_centro_costo, hco_porcentaje/*, hco_nomenclatura_contable*/)  
SELECT hpa_codigo hco_codhpa, cco_codigo hco_codcco, cco_descripcion hco_nombre_centro_costo,  
	cpp_porcentaje hco_porcentaje --, cco_nomenclatura_contable hco_nomenclatura_contable  
FROM sal.hpa_hist_periodos_planilla  
JOIN eor.plz_plazas ON plz_codigo = hpa_codplz  
JOIN eor.cpp_Centros_costo_plaza ON cpp_Codplz = plz_codigo  
JOIN eor.cco_Centros_De_costo ON cco_Codigo = cpp_codcco  
WHERE hpa_codppl = @codppl  

--*GENERACIÓN DE RESERVAS (PROVISIONES)
--execute pa.GenPla_Genera_Reservas @sessionId, @codppl, @userName
	
--*GENERACIÓN DE DATOS PREELABORADA
--Ejecución de proceso de llenado de tabla de seguro social
--execute pa.GenPla_llena_SIPE @codcia,@anio,@mes 

--*GENERACIÓN DE PARTIDA CONTABLE
--execute pa.genpla_poliza_contable @sessionId,@codppl,@userName

--*CAMBIA A ESTADO GENERADO EL PERIODO DE PLANILLA
UPDATE sal.ppl_periodos_planilla 
SET ppl_Estado = 'Generado'
WHERE ppl_Codigo  =@codppl


-- Marca Incapacidades como aplicadas en planilla
--UPDATE acc.pie_periodos_incapacidad
--   set pie_aplicado_planilla = 1
--WHERE pie_aplicado_planilla = 0
--AND pie_planilla_autorizada = 0
--AND (pie_valor_a_pagar > 0 or PIE_VALOR_A_DESCONTAR > 0)
--AND pie_codppl = @codppl
--AND exists (select null 
--              from acc.ixe_incapacidades
--              JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
--              JOIN acc.rin_riesgos_incapacidades on rin_codigo= ixe_codrin
--			where ixe_codigo = pie_codixe
--              AND rin_utiliza_fondo = 1
--			)

UPDATE sal.tnn_tiempos_no_trabajados
SET tnn_aplicado_planilla = 1
WHERE EXISTS (
	SELECT 1
	FROM sal.ods_otros_descuentos
	WHERE ods_lote_masivo = tnn_codigo
	AND ods_aplicado_planilla = 1
	AND ods_codppl = 1018
)

DELETE FROM sal.ods_otros_descuentos
WHERE EXISTS (
	SELECT 1
	FROM sal.tnn_tiempos_no_trabajados
	WHERE tnn_codigo = ods_lote_masivo
	AND tnn_codppl = 1018
)

EXEC pa.GenPla_Genera_Reservas @codppl = @codppl
EXEC pa.GenPla_genera_partida_contable @codppl = @codppl

COMMIT TRANSACTION

END

GO


