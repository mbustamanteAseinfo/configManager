IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.fn_anexo03')
                    AND type IN ( N'FN', N'TF', N'IF' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP FUNCTION [pa].[fn_anexo03]
GO
CREATE FUNCTION [pa].[fn_anexo03]
(
   @codcia  int,
   @anio    int,
   @mes     int,
   @coduni	int,
   @verAcumulado varchar(1),
   @destino varchar(1) = null
)
-- select * from pa.fn_anexo03 (1, 2015, null, null, null, null)
RETURNS @tmp_anexo03 TABLE
(
	rpe_codemp int,
	rpe_nombre_nit varchar(108),
	rpe_nit varchar(20),
	rpe_cip varchar(20),
	meses int,
	neto numeric(12,2),
	renta numeric(12,2),
	educativo numeric(12,2),
	descuentos_renta numeric(12,2),
	interes_h numeric(12,2),
	interes_e numeric(12,2),
	p_seg_h numeric(12,2),
	gravable numeric(12,2),
	impuesto numeric(12,2),
	impuesto_gr numeric(12,2),
	col1216 numeric(12,2),
	col2021 numeric(12,2),
	ajuste_emp numeric(12,2),
	ajuste_fisco numeric(12,2),
	titulo varchar(50),
	rpe_cia_nit varchar(18),
	rpe_cia_des varchar(150),
	rpe_giro varchar(500),
	rpe_direccion varchar(200),
	rpe_telefonos varchar(30),
	rpe_anio int,
	grupo varchar(10),
	grupo_cod varchar(1),
	dependientes int,
	cia_rep_nombre varchar(100),
	cia_patronal varchar(20),
	uni_codigo int,
	uni_nombre varchar(80),
	declara_ingresos varchar(2),
	declara_ingresos_cod varchar(1),
	salario_especie numeric(12,2),
	ingresosGR numeric(12,2),
	ingresosSalarioSinRetencion numeric(12,2),
	aporte_jubilacion numeric(12,2),
	renta_gr numeric(12,2),
	exencion_ley6_2005 numeric(12,2),
	rpe_pasaporte varchar(20),
	rpe_tipo varchar(10),
	rpe_tipo_cod int,
	rpe_doc_tipo varchar(20),
	ingresosBono numeric(12,2),
	col2528 numeric(12,2),
	favor_empleado numeric(12,2)
)
AS
BEGIN

declare @ini datetime,@fin datetime,
		@codagr_salario int, @codagr_gasto_rep int, @agrupador_bono int,
		@codtdo_cedula int,
		@codtdo_pasaporte int,
		@codtdc_seguro_educativo int,
		@codtdc_renta int,
		@codtdc_renta_gasto_rep int,
		@ISR_deduccion_legal numeric(12,2)

select @destino = coalesce(@destino, 'R')

set @codagr_salario = COALESCE(gen.get_valor_parametro_int ('Anexo03_CodigoAgrupador_Salario', 'pa', null, null, null), -1) -- SALARIO
set @codagr_gasto_rep = COALESCE(gen.get_valor_parametro_int ('Anexo03_CodigoAgrupador_GastoRep', 'pa', null, null, null), -1) -- GASTO DE REPRESENTACION
set @agrupador_bono = COALESCE(gen.get_valor_parametro_int ('Anexo03_CodigoAgrupador_Bono', 'pa', null, null, null), -1) -- BONIFICACION

select @codtdc_seguro_educativo = COALESCE(gen.get_valor_parametro_int ('CodigoTDC_SeguroEducativo', null, null, @codcia, null), -1),
	   @codtdc_renta = COALESCE(gen.get_valor_parametro_int ('CodigoTDC_ISR', null, null, @codcia, null), -1),
	   @codtdc_renta_gasto_rep = COALESCE(gen.get_valor_parametro_int ('CodigoTDC_ISR_GastoRep', null, null, @codcia, null), -1),
	   @ISR_deduccion_legal = isnull(gen.get_valor_parametro_money('ISRDeduccionLegal', 'pa', null, null, null), 800),
	   @codtdo_cedula = COALESCE(gen.get_valor_parametro_int ('CodigoDoc_Cedula', 'pa', null, null, null), -1),
	   @codtdo_pasaporte = COALESCE(gen.get_valor_parametro_int ('CodigoDoc_Pasaporte', 'pa', null, null, null), -1)

set @ini = cast('01/01/' + cast(@anio as varchar) as datetime)

if coalesce(@mes, 0) <> 0
begin
	set @fin = cast( (case when @mes in (1,3,5,7,8,10,12) then '31' when @mes = 2 then '28' when @mes in (4,6,9,11) then '30' end) + '/' + gen.lpad(convert(varchar, @mes),2,'0') + '/' + cast(@anio as varchar) as datetime)
end
else
begin
	set @fin = cast('31/12/' + cast(@anio as varchar) as datetime)
	set @mes = 12
end

insert into @tmp_anexo03
select  rpe_codemp,
		rpe_nombre_nit,
		rpe_nit,
		rpe_cip,
		(case when meses > 12 then 12 else meses end) meses,
		neto,
		renta,
		educativo,
		descuentos_renta,
		interes_h,
		interes_e,
		p_seg_h,
		gravable,
		impuesto,
		impuesto_gr,
		col1216,
		col2021,
		ajuste_emp,
		ajuste_fisco,
		titulo,
		rpe_cia_nit,
		rpe_cia_des,
		rpe_giro,
		rpe_direccion,
		rpe_telefonos,
		rpe_anio,
		grupo,
		grupo_cod,
		dependientes,
		cia_rep_nombre,
		cia_patronal,
		uni_codigo,
		uni_nombre,
		declara_ingresos,
		declara_ingresos_cod,
		salario_especie,
		ingresosGR,
		ingresosSalarioSinRetencion,
		aporte_jubilacion,
		renta_gr,
		exencion_ley6_2005,
		rpe_pasaporte,
		rpe_tipo,
		rpe_tipo_cod,
		rpe_doc_tipo,
		ingresosBono,
		col2528,
		favor_empleado
from (
	select  UNI_CODIGO,
			UNI_NOMBRE,
			declara_ingresos,
			0 rpe_codemp,
			rpe_nombre_nit,
			rpe_cip,
			rpe_nit,
			rpe_pasaporte,
			grupo,
			grupo_cod,
			dependientes,
			descuentos_renta,
			rpe_cia_nit,
			rpe_cia_des,
			rpe_giro,
			rpe_direccion,
			rpe_telefonos,
			cia_rep_nombre,
			cia_patronal,
			rpe_anio,
			meses,
			neto,
			ingresosGR,
			ingresosBono,
			renta,
			renta_gr,
			--credito_aplicado,
			educativo,
			gravable,
			(case when meses >= 12 THEN ajuste_emp ELSE 0.00 END) ajuste_emp,
			impuesto,
			impuesto_gr,
			col1216,
			col2528,
			interes_h,
			interes_e,
			p_seg_h,
			salario_especie,
			ingresosSalarioSinRetencion,
			aporte_jubilacion,
			exencion_ley6_2005,
			col2021,
			rpe_tipo,
			rpe_tipo_cod,
			rpe_doc_tipo,
		   convert(numeric(12,2),
		   (case coalesce(declara_ingresos, 'N')
			when 'S' then 0.00
			else (case when meses >= 12 then convert(numeric(12,2), (case when (renta + renta_gr + ajuste_emp) > (impuesto + impuesto_gr) then (renta + renta_gr + ajuste_emp) - (impuesto + impuesto_gr) else 0.00 end)) else 0.00 end) --> ajuste_emp
			end))
		   favor_empleado,
		   (case when meses >= 12
			then
			   (case coalesce(convert(varchar(1), declara_ingresos), 'N')
				when 'S' then 0.00
				else convert(numeric(12,2), 
						(case when (impuesto + impuesto_gr - col2528) > 0
							  then (impuesto + impuesto_gr - col2528)
							  else 0
							  end
						)) --> ajuste_fisco
				end)
			else 0.00
			end)
		   ajuste_fisco,
		   'Del 01 de Enero al 31 de Diciembre de ' + cast(@anio as varchar) titulo,
		   (CASE coalesce(declara_ingresos, 'N') WHEN 'S' THEN 2 ELSE 1 END) declara_ingresos_cod
	from (
		select  UNI_CODIGO, UNI_NOMBRE, declara_ingresos, rpe_nombre_nit,
				rpe_cip,
				gen.lpad(rpe_nit, 2, '0') rpe_nit,
				rpe_pasaporte,
				grupo,
				grupo_cod,
				dependientes,
				descuentos_renta,
				rpe_cia_nit,
				rpe_cia_des,
				rpe_giro,
				rpe_direccion,
				rpe_telefonos,
				cia_rep_nombre,
				cia_patronal,
				rpe_anio,
				meses,
				neto,
				ingresosGR,
				ingresosBono,
				renta,
				renta_gr,
				credito_aplicado,
				educativo,
				gravable + ingresosGR gravable,
				ajuste_emp,
				convert(numeric(12,2), 
				-- 27/04/2015 Henry Sandoval
				-- Si el destino es Reporte, se muestra siempre el impuesto causado
				-- caso contrario se aplica la validacion del numero de meses
				(case @destino
				 when 'R'
				 then
					isnull((select round(isnull(valor, 0) + (gravable - isnull(excedente, 0)) * isnull(porcentaje, 0) / 100, 2)
							from gen.get_valor_rango_parametro('TablaRentaMensual', cia_codpai, null, null, null, null) tabla_isr
							where gravable >= inicio and gravable <= fin
							),0)
				else 
					(case when meses >= 12
					 then
						isnull((select round(isnull(valor, 0) + (gravable - isnull(excedente, 0)) * isnull(porcentaje, 0) / 100, 2)
								from gen.get_valor_rango_parametro('TablaRentaMensual', cia_codpai, null, null, null, null) tabla_isr
								where gravable >= inicio and gravable <= fin
								),0)
					 else 0.00
					 end)
				end)
				)
				impuesto, --renta /*+ renta_gr*/ impuesto,
				convert(numeric(12,2), 
					isnull((select round(isnull(valor, 0) + (ingresosGR - isnull(excedente, 0)) * isnull(porcentaje, 0) / 100, 2)
						 from gen.get_valor_rango_parametro('TablaRentaMensualGastoRep', cia_codpai, null, null, null, null) tabla_isr_gr
						 where ingresosGR >= inicio and ingresosGR <= fin),0))
				impuesto_gr,
				(descuentos_renta+interes_h+interes_e+p_seg_h+educativo) col1216,
				   convert(numeric(12,2),
					   0.00 + --> exencion_ley6_2005
					   renta + 
					   renta_gr + 
					   ajuste_emp
				   ) col2528,
				interes_h,
				interes_e,
				p_seg_h,
				salario_especie,
				ingresosSalarioSinRetencion,
				aporte_jubilacion,
				exencion_ley6_2005,
				col2021,
				rpe_tipo,
				rpe_tipo_cod,
				rpe_doc_tipo
		from (
			select  UNI_CODIGO, UNI_NOMBRE, declara_ingresos, rpe_nombre_nit,
					rpe_cip,
					rpe_nit,
					rpe_pasaporte,
					grupo,
					grupo_cod,
					dependientes,
					descuentos_renta,
					rpe_cia_nit,
					rpe_cia_des,
					rpe_giro,
					rpe_direccion,
					rpe_telefonos,
					cia_rep_nombre,
					cia_patronal,
					cia_codpai,
					rpe_anio,
					--declara_ingresos,
					SUM(meses) meses,
					SUM(neto) neto,
					SUM(ingresosGR) ingresosGR,
					SUM(ingresosBono) ingresosBono,
					SUM(renta) renta,
					SUM(renta_gr) renta_gr,
					SUM(credito_aplicado) credito_aplicado,
					SUM(educativo) educativo,
					(SUM(neto) - SUM(descuentos_renta) - SUM(educativo)) gravable,
					SUM(ajuste_emp) ajuste_emp,
					0.00 interes_h,
					0.00 interes_e,
					0.00 p_seg_h,
					0.00 salario_especie,
					0.00 ingresosSalarioSinRetencion,
					0.00 aporte_jubilacion,
					0.00 exencion_ley6_2005,
					0.00 col2021,
				   (case rpe_cip when '' then 'Pasaporte' else 'RUC' end) rpe_tipo,
				   (case rpe_cip when '' then 2 else 1 end) rpe_tipo_cod,
				   (case rpe_cip when '' then rpe_pasaporte else rpe_cip end) rpe_doc_tipo
			from (
				select  distinct UNI_CODIGO, declara_ingresos, rpe_nombre_nit,
						rpe_cip,
						rpe_nit,
						rpe_pasaporte,
						grupo,
						grupo_cod,
						dependientes,
						descuentos_renta,
						rpe_cia_nit,
						rpe_cia_des,
						rpe_giro,
						rpe_direccion,
						rpe_telefonos,
						cia_rep_nombre,
						cia_patronal,
						cia_codpai,
						rpe_anio,
						--UNI_CODIGO,
						--UNI_NOMBRE,
						--declara_ingresos,
						pa.fn_calcula_meses_anexo03 (@codcia, rpe_codexp, @anio, @mes) meses,
						pa.fn_agrupador_valores_periodo_anexo03(@codcia,rpe_codexp,@anio,@mes, @codagr_salario, @verAcumulado) +
						pa.fn_agrupador_valores_periodo_anexo03(@codcia,rpe_codexp,@anio,@mes,@agrupador_bono, @verAcumulado) -- Agregado el 23/02/2013 para mostrar el total de montos por bonificaciones
						neto,
						pa.fn_agrupador_valores_periodo_anexo03(@codcia,rpe_codexp,@anio,@mes,@codagr_gasto_rep, @verAcumulado) ingresosGR, -- Ingresos Gasto de Representación Anexo 03
						pa.fn_agrupador_valores_periodo_anexo03(@codcia,rpe_codexp,@anio,@mes,@agrupador_bono, @verAcumulado) ingresosBono, -- Ingresos Bonificacion Anexo 03
					   isnull((select sum(isnull(dss_valor,0))
							   from sal.dss_descuentos
							   join sal.ppl_periodos_planilla
							   on ppl_codigo = dss_codppl
							   join exp.emp_empleos
							   on emp_codigo = dss_codemp
							   where emp_codexp = rpe_codexp
							   and dss_codtdc = @codtdc_renta --Renta
							   and ppl_estado = 'Autorizado'
							   and ppl_anio = @anio
							   AND ppl_mes <= @mes
							   AND ppl_mes >= (CASE @verAcumulado WHEN 'S' THEN 1 ELSE @mes END)),0) 
						renta,
					   isnull((select sum(isnull(dss_valor,0))
							   from sal.dss_descuentos
							   join sal.ppl_periodos_planilla
							   on ppl_codigo = dss_codppl
							   join exp.emp_empleos
							   on emp_codigo = dss_codemp
							   where emp_codexp = rpe_codexp
							   and dss_codtdc = @codtdc_renta_gasto_rep --Renta Gasto de Representacion
							   and ppl_estado = 'Autorizado'
							   and ppl_anio = @anio
							   AND ppl_mes <= @mes
							   AND ppl_mes >= (CASE @verAcumulado WHEN 'S' THEN 1 ELSE @mes END)),0)
						renta_gr,
						--COALESCE((SELECT SUM(ACR_MONTO)
						--			FROM PLA_ACR_APLICACION_CREDITOS_RENTA
						--			JOIN PLA_PPL_PARAM_PLANI
						--			ON PPL_CODCIA = ACR_CODCIA
						--			AND PPL_CODTPL = ACR_CODTPL
						--			AND PPL_CODPLA = ACR_CODPLA
						--			WHERE ACR_ESTADO = 'A'
						--			AND PPL_ESTADO = 'A'
						--			and ppl_anio_cont = @anio
						--			AND PPL_MES_CONT <= @mes
						--			AND PPL_MES_CONT >= (CASE @verAcumulado WHEN 'S' THEN 1 ELSE @mes END)
						--			AND ACR_CODEMP = rpe_codemp
						--			), 0) credito_aplicado,
					   0.00 credito_aplicado,
					   isnull((select sum(isnull(dss_valor,0))
							   from sal.dss_descuentos
							   join sal.ppl_periodos_planilla
							   on ppl_codigo = dss_codppl
							   join exp.emp_empleos
							   on emp_codigo = dss_codemp
							   where emp_codexp = rpe_codexp
							   and dss_codtdc = @codtdc_seguro_educativo -- Seguro Educativo
							   and ppl_estado = 'Autorizado'
							   and ppl_anio = @anio
							   and ppl_anio < 2010 -- El seguro educativo solo se muestra previo al 2010
							   ),0) educativo,
					   0.00 ajuste_emp, -- dbo.fn_get_credito_renta_emp(rpe_codemp, @anio) ajuste_emp,
					   COALESCE((SELECT uni_descripcion FROM eor.uni_unidades WHERE eor.uni_unidades.uni_codigo = DATOS.UNI_CODIGO), '') UNI_NOMBRE
				from (
					select distinct exp_codigo rpe_codemp, exp_codigo rpe_codexp,
						   exp_nombre rpe_nombre_nit, 
						   cedulas.ide_numero rpe_cip,
						   exp_digito_verificador rpe_nit,
						   coalesce(pasaportes.ide_numero, '') rpe_pasaporte,
						   coalesce(exp_clase_renta, '') + cast(exp_numero_dependientes as varchar) grupo,
						   (case coalesce(exp_clase_renta, 'A') when 'A' then 5 when 'E' then 6 else 0 end) grupo_cod,
						   exp_numero_dependientes dependientes,
						   (case when coalesce(exp_clase_renta, 'A') = 'E' then @ISR_deduccion_legal else 0 end) descuentos_renta,
						   cia_nit rpe_cia_nit,
						   cia_descripcion rpe_cia_des,
						   cia_giro rpe_giro, 
						   cia_direccion rpe_direccion,
						   cia_telefonos rpe_telefonos,
						   coalesce((select top 1 coalesce(exp_primer_ape, '') + ' ' + coalesce(exp_primer_nom, '')
									 from eor.rep_representantes_legales
									 join exp.exp_expedientes
									 on exp_codigo = rep_codexp
									 where rep_activo = 1
									 and rep_codcia = @codcia), '') cia_rep_nombre,
						   cia_patronal,
						   cia_codpai,
						   @anio rpe_anio,
						   --UNI_CODIGO,
						   --UNI_NOMBRE,
						   --coalesce(dpl_declara_ingresos, 'N') declara_ingresos
						   exp_declara_ingresos declara_ingresos,
						   pa.fn_get_unidad_anexo03(cedulas.ide_numero) UNI_CODIGO
					from (select distinct exp_codigo, 
								coalesce(exp_primer_ape, '') + ' ' + coalesce(exp_primer_nom, '') exp_nombre,
								coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_digito_verificador'), '') exp_digito_verificador,
								gen.get_pb_field_data(exp_property_bag_data, 'exp_clase_renta') exp_clase_renta,
								coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_numero_dependientes'), 0) exp_numero_dependientes,
								coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_declara_ingresos'), 'N') exp_declara_ingresos,
								tpl_codcia
						  from exp.exp_expedientes
						  join exp.emp_empleos
						  on emp_codexp = exp_codigo
						  join sal.tpl_tipo_planilla
						  on tpl_codigo = emp_codtpl
						  where tpl_codcia = @codcia
						  and exists (
								select inn_codemp
								from sal.inn_ingresos
								join sal.ppl_periodos_planilla
								on ppl_codigo = inn_codppl
								join sal.tpl_tipo_planilla
								on tpl_codigo = ppl_codtpl
								where tpl_codcia = @codcia
								and inn_codemp = emp_codigo
								and ppl_anio = @anio
								and inn_valor > 0)
					) expedientes
					left join (
						select ide_codexp, ide_numero
						from exp.ide_documentos_identificacion
						where ide_codtdo = @codtdo_cedula
					) cedulas
					on cedulas.ide_codexp = exp_codigo
					left join (
						select ide_codexp, ide_numero
						from exp.ide_documentos_identificacion
						where ide_codtdo = @codtdo_pasaporte
					) pasaportes
					on pasaportes.ide_codexp = exp_codigo
					join eor.cia_companias on cia_codigo = tpl_codcia
					--join PLA_UNI_UNIDAD on UNI_CODIGO = PLZ_CODUNI
					--where UNI_CODIGO = coalesce(@coduni, uni_codigo)
				) DATOS
				WHERE coalesce(UNI_CODIGO, -1) = coalesce(@coduni, coalesce(uni_codigo, -1))
			) DEVENGADO
			GROUP BY UNI_CODIGO, UNI_NOMBRE, declara_ingresos, rpe_nombre_nit,
					rpe_cip,
					rpe_nit,
					rpe_pasaporte,
					grupo,
					grupo_cod,
					dependientes,
					descuentos_renta,
					rpe_cia_nit,
					rpe_cia_des,
					rpe_giro,
					rpe_direccion,
					rpe_telefonos,
					cia_rep_nombre,
					cia_patronal,
					cia_codpai,
					rpe_anio--,
					--declara_ingresos
		) TOTALES
	) IMPUESTOS
) ANEXO03

return
END
