IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Inicializacion_vac')
                    AND type IN ( N'P', N'PC' ) )

/****** Object:  StoredProcedure [pa].[GenPla_Inicializacion_vac]    Script Date: 16-01-2017 3:23:44 PM ******/
DROP PROCEDURE [pa].[GenPla_Inicializacion_vac]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Inicializacion_vac]    Script Date: 16-01-2017 3:23:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Inicializacion_vac]
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
	--and (sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
	--     or inn_codemp in (select emp_codigo from exp.emp_empleos
	--	                    where emp_estado = 'R' )) /* or emp_codtpl <> @codtpl*/

	-- DESCUENTOS
	DELETE FROM sal.dss_descuentos
	WHERE dss_codppl = @codppl
	--and (sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
	--     or dss_codemp in (select emp_codigo from exp.emp_empleos
	--	                    where emp_estado = 'R' ))

	-- RESERVAS
	DELETE FROM sal.res_reservas
	WHERE res_codppl = @codppl
	--and (sal.empleado_en_gen_planilla(@sessionId, res_codemp) = 1
	--     or res_codemp in (select emp_codigo from exp.emp_empleos
	--	                    where emp_estado = 'R' ))

	-- HISTORICO DE PLANILLAS CALCULADAS
	DELETE 
	FROM sal.hpa_hist_periodos_planilla
	WHERE hpa_codppl = @codppl
	--and (sal.empleado_en_gen_planilla(@sessionId, hpa_codemp) = 1
	--     or hpa_codemp in (select emp_codigo from exp.emp_empleos
	--	                    where emp_estado = 'R' ))

	-- Genera las cuotas de los descuentos cíclicos
	EXEC pa.GenPla_DCC_GeneraCuotas @sessionId, @codppl, @userName 

	-- Genera las cuotas de los ingresos cíclicos
	--exec pa.GenPla_IGC_GeneraCuotas @sessionId, @codppl, @userName 

	-- Genera los montos por tiempos no trabajados
	--exec pa.GenPla_TNT_Revalua @sessionId, @codppl, @userName 

	-- Genera los montos de las horas extras
	--exec pa.GenPla_HorasExtras_Revalua @sessionId, @codppl, @userName 
	
	-- Genera periodos de incapacidad
	--exec pa.GenPla_INC_GeneraPeriodosIncapacidad @sessionId, @codppl, @userName 
	
	--Genera la Renta para el Salario
	EXEC pa.GenPla_GeneraRenta  @sessionId, @codppl, @userName 
	
	--Genera la Renta para el Gasto de Representación
	EXEC pa.GenPla_GeneraRenta_GastoRep @sessionId, @codppl, @userName 

	-- Genera los montos de los ingresos eventuales cuyo monto no es fijo
    EXEC pa.GenPla_IngresosEventuales_Revalua @sessionId, @codppl, @userName 

	-- Genera los pagos a efectuar por vacacion al solicitar 15 dias 
	--exec pa.GenPla_Pago_Vacacion @sessionId, @codppl, @userName 
	EXEC pa.proc_genera_montos_pago_vacacion @codppl, 'S'
	EXEC pa.proc_genera_montos_pago_vacacion @codppl, 'G'

COMMIT TRANSACTION
RETURN

GO


