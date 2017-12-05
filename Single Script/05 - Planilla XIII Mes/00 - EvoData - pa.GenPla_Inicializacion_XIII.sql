IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Inicializacion_XIII')
                    AND type IN ( N'P', N'PC' ) )


/****** Object:  StoredProcedure [pa].[GenPla_Inicializacion_XIII]    Script Date: 16-01-2017 2:49:17 PM ******/
DROP PROCEDURE [pa].[GenPla_Inicializacion_XIII]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Inicializacion_XIII]    Script Date: 16-01-2017 2:49:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Inicializacion_XIII]
	@sessionId UNIQUEIDENTIFIER = NULL,
    @codppl INT,
    @userName VARCHAR(100) = NULL
AS

set @userName = isnull(@userName, system_user)

set nocount on
set dateformat dmy

begin transaction
	
	declare @codcia int, @codtpl int, @codtpl_quincenal int

	SELECT @codcia = tpl_codcia, @codtpl = tpl_codigo
	FROM sal.ppl_periodos_planilla
	JOIN sal.tpl_tipo_planilla
	ON tpl_codigo = ppl_codtpl
	WHERE ppl_codigo = @codppl

	-- OBTIENE EL TIPO DE PLANILLA RESPECTIVO A LA EMPRESA
	select @codtpl_quincenal = isnull(gen.get_valor_parametro_int('CodigoPlanillaQuincenal', null, null, @codcia, null), 1)

	-- INGRESOS
	delete from sal.inn_ingresos
	where inn_codppl = @codppl
	and (sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
	     or inn_codemp in (select emp_codigo from exp.emp_empleos
		                    where emp_estado = 'R' )) /* or emp_codtpl <> @codtpl*/

	-- DESCUENTOS
	delete from sal.dss_descuentos
	where dss_codppl = @codppl
	and (sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
	     or dss_codemp in (select emp_codigo from exp.emp_empleos
		                    where emp_estado = 'R' ))

	-- RESERVAS
	delete from sal.res_reservas
	where res_codppl = @codppl
	and (sal.empleado_en_gen_planilla(@sessionId, res_codemp) = 1
	     or res_codemp in (select emp_codigo from exp.emp_empleos
		                    where emp_estado = 'R' ))

	-- HISTORICO DE PLANILLAS CALCULADAS
	DELETE 
	FROM sal.hpa_hist_periodos_planilla
	WHERE hpa_codppl = @codppl
	AND (sal.empleado_en_gen_planilla(@sessionId, hpa_codemp) = 1
	     OR hpa_codemp IN (SELECT emp_codigo FROM exp.emp_empleos
		                    WHERE emp_estado = 'R' ))

	


	--Genera la Renta para el Salario
	EXEC pa.GenPla_GeneraRenta  @sessionId, @codppl, @userName 
	
	--Genera la Renta para el Gasto de Representación
	EXEC pa.GenPla_GeneraRenta_GastoRep @sessionId, @codppl, @userName 

	SET DATEFORMAT YMD

	DELETE FROM sal.dsx_datos_salario_xiii
	WHERE dsx_codppl = @codppl

	DELETE FROM sal.dgx_datos_gastorep_xiii
	WHERE dgx_codppl = @codppl

	-- Salario
	INSERT INTO sal.dsx_datos_salario_xiii
			(dsx_codemp, dsx_acumulado, dsx_valor_xiii, dsx_dias, dsx_codppl)
	SELECT CODEMP, ACUMULADO, XIII, DIAS, @codppl
	FROM sal.fn_ingresos_acumulados_xiii(@codcia, @codtpl, @codppl, NULL, NULL, 'S')
	 
	-- Gasto de Representacion
	INSERT INTO sal.dgx_datos_gastorep_xiii
			(dgx_codemp, dgx_acumulado, dgx_valor_xiii, dgx_dias, dgx_codppl)
	SELECT CODEMP, ACUMULADO, XIII, DIAS, @codppl
	FROM sal.fn_ingresos_acumulados_xiii(@codcia, @codtpl, @codppl, NULL, NULL, 'G')

	-- Genera los montos de pago del decimo tercero
	--exec pa.GenPla_Datos_Prom_XIII @sessionId, @codppl, @userName
	DELETE FROM pa.dpx_datos_prom_xiii WHERE dpx_codppl = @codppl

	INSERT INTO pa.dpx_datos_prom_xiii
	SELECT @codcia codcia, @codtpl codtpl, @codppl codppl, CODEMP, SUM(ISNULL(XIII, 0)), SUM(ISNULL(XIII_GR, 0)), 120, 120
	FROM (
		SELECT CODEMP, ACUMULADO, XIII, 0.00 XIII_GR, NULL dias, @codppl codppl
		FROM sal.fn_ingresos_acumulados_xiii(@codcia, @codtpl, @codppl, NULL, NULL, 'S')
		UNION
		SELECT CODEMP, ACUMULADO, 0.00 XIII, XIII AS XIII_GR, NULL, @codppl
		FROM sal.fn_ingresos_acumulados_xiii(@codcia, @codtpl, @codppl, NULL, NULL, 'G')
	) v
	GROUP BY CODEMP


COMMIT TRANSACTION
RETURN

GO


