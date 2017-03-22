IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Finalizacion_XIII')
                    AND type IN ( N'P', N'PC' ) )

/****** Object:  StoredProcedure [pa].[GenPla_Finalizacion_XIII]    Script Date: 16-01-2017 2:54:17 PM ******/
DROP PROCEDURE [pa].[GenPla_Finalizacion_XIII]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Finalizacion_XIII]    Script Date: 16-01-2017 2:54:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Finalizacion_XIII]
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
	group by dss_codppl, dss_codemp, dss_codtdc, dss_codmon, dss_unidad_tiempo

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



	-- Genera la tabla de historicos
	-- HISTORICO DE PLANILLAS CALCULADAS

	INSERT INTO sal.hpa_hist_periodos_planilla
	   (hpa_codppl, hpa_codemp, hpa_nombres_apellidos, hpa_apellidos_nombres, hpa_fecha_ingreso, 
		hpa_codafp, hpa_nombre_afp, hpa_codmon, hpa_tasa_cambio, hpa_salario, hpa_salario_hora, 
		hpa_codtco, hpa_codplz, hpa_nombre_plaza, hpa_coduni, hpa_nombre_unidad, hpa_codarf, hpa_nombre_areafun, 
		hpa_codcdt, hpa_nombre_centro_trabajo, hpa_codpue, hpa_nombre_puesto, hpa_nombre_tipo_planilla, hpa_nombre_periodo_planilla, 
		hpa_session_id, hpa_usuario_grabacion, hpa_fecha_grabacion,
		hpa_codcco, hpa_nombre_centro_costo, hpa_cco_nomenclatura_contable
		/*hpa_codjor,hpa_jornada,hpa_horas_x_semana,hpa_rata*/
		)
	SELECT @codppl, emp_codigo, exp_nombres_apellidos, exp_apellidos_nombres, emp_fecha_ingreso, 
		   NULL afp_codigo, NULL afp_nombre, inn_codmon, gen.get_tasa_cambio(inn_codmon, ppl_fecha_fin), ISNULL(valor, 0), ISNULL(valor_hora, 0),
		   tco_codigo, plz_codigo, plz_nombre, uni_codigo, uni_descripcion, arf_codigo, arf_nombre,
		   cdt_codigo, cdt_descripcion, pue_codigo, pue_nombre, tpl_descripcion, LEFT(CONVERT(VARCHAR, ppl_fecha_ini, 100), 11) + ' - ' + LEFT(CONVERT(VARCHAR, ppl_fecha_fin, 100), 11),
		   @sessionId, @userName, @now
		   , codcco, cco_descripcion, cco_nomenclatura_contable
		   /* jor_Codigo, jor_descripcion, jor_total_horas,  case when isnull(jor_total_horas,0) > 0 
															   then (isnull(esa_valor, 0) / (52/12.000000)) / jor_total_horas
															   else 0
														   end */
	  FROM exp.emp_empleos
	  JOIN (SELECT inn_codemp, MAX(inn_codmon) inn_codmon
			  FROM sal.inn_ingresos 
			 WHERE inn_codppl = @codppl 
			   --and sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
			 GROUP BY inn_codemp) inn ON inn_codemp = emp_codigo
	  JOIN sal.ppl_periodos_planilla ON ppl_codigo = @codppl
	  JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
	  --left join exp.esa_est_sal_actual_empleos_v on esa_codemp = emp_codigo and esa_es_salario_base = 1
	  LEFT JOIN exp.fn_get_datos_rubro_salarial(NULL, 'S', @fecha_fin, 'pa')
	  ON codemp = emp_codigo
	  JOIN exp.tco_tipos_de_contrato ON tco_codigo = emp_codtco
	  JOIN eor.plz_plazas ON plz_codigo = emp_codplz
	  JOIN eor.uni_unidades ON uni_codigo = plz_coduni
	  JOIN eor.arf_areas_funcionales ON arf_codigo = uni_codarf
	  JOIN eor.cdt_centros_de_trabajo ON cdt_codigo = plz_codcdt
	  JOIN eor.pue_puestos ON pue_codigo = plz_codpue
	  JOIN exp.exp_expedientes ON exp_codigo = emp_codexp
	  LEFT JOIN sal.jor_jornadas ON jor_codigo = emp_codjor
	  LEFT JOIN (
			SELECT codplz, codcco, cco_descripcion, cco_nomenclatura_contable
			FROM (
				SELECT cpp_codplz codplz, MAX(cpp_codcco) codcco
				FROM eor.cpp_centros_costo_plaza
				GROUP BY cpp_codplz
			) v
			JOIN eor.cco_centros_de_costo
			ON cco_codigo = codcco
	  ) w
	  ON w.codplz = plz_codigo
	  --left join exp.afp_afp on afp_codigo = gen.get_pb_field_data_int(emp_property_bag_data, 'codAFP')


	--*GENERA HISTORICO DE CENTROS DE COSTO  
	DELETE FROM  sal.hco_hist_cco_periodos_planilla    
	WHERE EXISTS(SELECT NULL FROM sal.hpa_hist_periodos_planilla  
				 WHERE hpa_Codppl = @codppl AND hpa_codigo = hco_codhpa)  
     
	INSERT INTO sal.hco_hist_cco_periodos_planilla 
	(hco_codhpa, hco_codcco, hco_nombre_centro_costo, hco_porcentaje/*, hco_nomenclatura_contable*/)  
	SELECT hpa_codigo hco_codhpa, cco_codigo hco_codcco, cco_descripcion hco_nombre_centro_costo,  
	 cpp_porcentaje hco_porcentaje --, cco_nomenclatura_contable hco_nomenclatura_contable  
	FROM sal.hpa_hist_periodos_planilla  
	JOIN eor.plz_plazas ON plz_codigo = hpa_codplz  
	JOIN eor.cpp_Centros_costo_plaza ON cpp_Codplz = plz_codigo  
	JOIN eor.cco_Centros_De_costo ON cco_Codigo = cpp_codcco  
	WHERE hpa_codppl = @codppl  
	
	--*GENERACIÓN DE PARTIDA CONTABLE
	EXECUTE pa.genpla_poliza_contable @sessionId,@codppl,@userName

	--*CAMBIA A ESTADO GENERADO EL PERIODO DE PLANILLA
	UPDATE sal.ppl_periodos_planilla 
	SET ppl_Estado = 'Generado'
	WHERE ppl_Codigo  =@codppl


COMMIT TRANSACTION

END

GO


