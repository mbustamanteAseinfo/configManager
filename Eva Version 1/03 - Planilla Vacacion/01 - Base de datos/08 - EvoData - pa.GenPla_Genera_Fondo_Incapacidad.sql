IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Genera_Fondo_Incapacidad')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_Genera_Fondo_Incapacidad]    Script Date: 16-01-2017 4:00:02 PM ******/
DROP PROCEDURE [pa].[GenPla_Genera_Fondo_Incapacidad]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Genera_Fondo_Incapacidad]    Script Date: 16-01-2017 4:00:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Genera_Fondo_Incapacidad]
    @codppl INT,
    @usuario VARCHAR(50) = NULL
    
AS

set dateformat dmy

declare @codcia int,
        @ini datetime,
        @fin datetime,
        @anio int,
        @frec int,
        @maximodias float,
        @diasadjudicados float,
		@codrin int

select @codcia = tpl_codcia,
       @ini = ppl_fecha_ini,
       @fin = ppl_fecha_fin,
       @anio = ppl_anio,
       @frec = ppl_frecuencia
  from sal.ppl_periodos_planilla
  join sal.tpl_tipo_planilla
    on tpl_Codigo = ppl_Codtpl
 where ppl_codigo = @codppl

select @diasAdjudicados = gen.get_valor_parametro_int('FondoIncapacidadDias', cia_codpai, null, null, null),
       @maximodias = isnull(gen.get_valor_parametro_int('FondoIncapacidadMaximoDias', cia_codpai, null, null, null),0),
	   @codrin = isnull(gen.get_valor_parametro_int('CodigoRiesgoFondo', cia_codpai, null, null, null),0)
  from eor.cia_companias
 where cia_codigo = @codcia

set @diasAdjudicados = isnull(@diasAdjudicados, 0)
set @maximodias = isnull(@maximodias, 0)

-- ya que este proceso se corre por cada quincena es necesario saber cuanto gana el empleado por quincena.
select @diasAdjudicados = round(@diasAdjudicados/24.00,4)
	
-- primero inserto los periodos que no existan para empleados nuevos
insert into acc.fin_fondos_incapacidad
	(fin_Codemp, fin_periodo,fin_codrin, fin_Desde, fin_hasta, fin_dias_derecho, fin_dias_incapacitado, fin_horas_incapacitado ,
		fin_usuario_grabacion, fin_fecha_grabacion)
	select emp_codigo,
		'General',
		@codrin,
		emp_fecha_ingreso emp_fecha_ini,
		@fin emp_fecha_fin,
		0 fin_dias_derecho,
		0 fin_dias_incapacitado,
		0 fin_horas_incapacitado,
		isnull(@usuario, SYSTEM_USER), GETDATE()
	from exp.emp_empleos 
	join eor.plz_plazas on plz_codigo = emp_codplz
	where plz_codcia = @codcia
	and emp_estado = 'A'
	and emp_fecha_ingreso <= @fin
	and NOT EXISTS (select 1 from acc.fin_fondos_incapacidad
						where fin_Codemp = emp_codigo
						and fin_periodo = 'General' )
	-- Omito los empleados que han tenido pago de vacaciones por Renuncia al Tiempo
	-- en el periodo de planilla para el cual se procesa el fondo de incapacidad
	and not exists (select 1 from acc.dva_dias_vacacion join acc.vac_vacaciones on vac_codigo = dva_codvac
					where dva_pagadas = 1 -- Renuncia al tiempo
					and dva_codppl = @codppl
					and vac_codemp = emp_codigo)
	
/* ACTUALIZA LOS DIAS DE INCAPACIDAD OTORGADOS */
UPDATE acc.fin_fondos_incapacidad
	SET fin_hasta = hasta, 
		fin_dias_derecho =  CASE WHEN dias > @maximodias THEN @maximodias ELSE dias END ,
		fin_dias_incapacitado = fin_dias_incapacitado + ISNULL(dias_incapacitado,0)
	FROM (
		SELECT fin_codigo codfin, 
				fin_Codemp codemp, 
				fin_periodo periodo, 
				fin_Codrin codrin,
				hasta = @fin,
				fin_dias_derecho +
				(CASE WHEN emp_fecha_ingreso > @ini THEN			
						CASE WHEN DAY(emp_fecha_ingreso) <= 15 THEN
							CASE WHEN DAY(emp_fecha_ingreso) = 1 THEN
								1
							ELSE 
								(gen.DateDiffComercial(emp_fecha_ingreso,CONVERT(DATETIME,'15/'+ CAST(MONTH(emp_fecha_ingreso) AS VARCHAR) + '/' + CAST(YEAR(emp_Fecha_ingreso) AS VARCHAR),103) + 1))/15.00 
							END 
						ELSE
							CASE WHEN DAY(emp_fecha_ingreso) = 16 THEN
								1
							ELSE
								(gen.DateDiffComercial(emp_fecha_ingreso,DATEADD(mm,1,CONVERT(DATETIME,'01/'+ CAST(MONTH(emp_fecha_ingreso) AS VARCHAR) + '/' + CAST(YEAR(emp_Fecha_ingreso) AS VARCHAR),103))- 1) + 1)/15.00 
							END 
						END * @diasAdjudicados 
				ELSE
						@diasAdjudicados 
				END 
				)  dias, /*DIAS DERECHO*/
			ISNULL((SELECT --sum(isnull(ixe_dias_incapacitado,0) + isnull(ixe_horas_incapacitado,0)/ 8.0000)
			        SUM(pie_dias)
					FROM acc.ixe_incapacidades 
					JOIN acc.rin_riesgos_incapacidades ON rin_codigo = ixe_codrin
					JOIN acc.pie_periodos_incapacidad ON pie_codixe = ixe_codigo 
					WHERE ixe_estado  ='Autorizado'
					AND ixe_Codppl = @codppl
					AND ixe_codemp = fin_Codemp
					AND rin_utiliza_fondo = 1
					AND pie_codfin = fin_codigo
					AND pie_valor_a_pagar != 0
					) ,0) dias_incapacitado
			FROM acc.fin_fondos_incapacidad
			JOIN exp.emp_empleos ON emp_codigo = fin_codemp	
			JOIN eor.plz_plazas ON plz_codigo = emp_codplz			
			WHERE plz_codcia = @codcia
			AND fin_periodo = 'General'
			AND emp_estado = 'A'
			-- Omito los empleados que han tenido pago de vacaciones por Renuncia al Tiempo
			-- en el periodo de planilla para el cual se procesa el fondo de incapacidad
			AND NOT EXISTS (SELECT 1 FROM acc.dva_dias_vacacion JOIN acc.vac_vacaciones ON vac_codigo = dva_codvac
							WHERE dva_pagadas = 1 -- Renuncia al tiempo
							AND dva_codppl = @codppl
							AND vac_codemp = emp_codigo)
		)data
WHERE codfin = fin_Codigo
	AND fin_Codemp = codemp
	AND fin_periodo = periodo

GO


