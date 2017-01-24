IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_GeneraRenta')
                    AND type IN ( N'P', N'PC' ) )

/****** Object:  StoredProcedure [pa].[GenPla_GeneraRenta]    Script Date: 16-01-2017 9:49:43 AM ******/
DROP PROCEDURE [pa].[GenPla_GeneraRenta]
GO

/****** Object:  StoredProcedure [pa].[GenPla_GeneraRenta]    Script Date: 16-01-2017 9:49:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_GeneraRenta]
   @sessionId UNIQUEIDENTIFIER = NULL,
   @codppl INT,
   @userName VARCHAR(100) = NULL
AS
BEGIN

SET NOCOUNT ON
SET DATEFORMAT DMY

declare @codpai varchar(2),
		@codcia int,
		@codtpl int,
		@codtpl_ordinario int,
		@codtpl_decimo int,
		@fecha_ini datetime,
		@fecha_fin datetime,
		@anio int,
		@isr_deduccion_legal money,
		@agr_base_xiii int,
		@agr_descuentos_isr int,
		@agr_base_isr int,
		@codrsa int,
		@anio_fin datetime,
		@quincenas_pendientes smallint,
		@decimos_pendientes numeric(12,4),
		@periodos_restantes_calculo numeric(12,4)

-- Toma el periodo de la planilla actual
SELECT @codcia = tpl_codcia,
       @codtpl = ppl_codtpl,
	   @fecha_ini = ppl_fecha_ini,
	   @fecha_fin = PPL_FECHA_FIN,
	   @anio = PPL_ANIO,
	   @codpai = cia_codpai
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
join eor.cia_companias on cia_codigo = tpl_codcia
WHERE ppl_codigo = @codppl

select @isr_deduccion_legal = gen.get_valor_parametro_float('ISRDeduccionLegal', @codpai, null, null, null)

-- Elimina los registros calculados previamente
DELETE FROM sal.rap_renta_anual_panama
 WHERE rap_codppl = @codppl
   --AND sal.empleado_en_gen_planilla(@sessionId, rap_codemp) = 1

--select @agr_base_xiii = gen.get_valor_parametro_int('BaseXIII_Salario_CodigoAgrupador', @codpai, null, null, null)
select @agr_base_xiii = gen.get_valor_parametro_int('BaseXIII_Salario_CodigoAgrupador', @codpai, null, null, null)

--SELECT @agr_descuentos_isr = agr_codigo FROM sal.agr_agrupadores where agr_codpai = @codpai AND agr_abreviatura = 'DescuentosRentaPTY' -- Agrupador para descuentos renta PTY
select @agr_descuentos_isr = agr_codigo from sal.agr_agrupadores where agr_codpai = @codpai and agr_abreviatura='DescuentosRentaPTY'
--SELECT @agr_base_isr = agr_codigo FROM sal.agr_agrupadores where agr_codpai = @codpai AND agr_abreviatura = 'IngresosRentaPTY'   -- Agrupador para ingresos renta PTY
select @agr_base_isr = agr_codigo from sal.agr_agrupadores where agr_codpai = @codpai and agr_abreviatura='IngresosRentaPTY'

-- SEPROSA 14/07/2014
--DECLARE @INCLUIR_DECIMO VARCHAR(1)
--SELECT @INCLUIR_DECIMO = COALESCE(gen.get_valor_parametro_varchar('ISRIncluyeDecimo', @codpai, null, null, null), 'S')

SET @codrsa = isnull(gen.get_valor_parametro_int ('CodigoRubroSalario',null,null,@codcia,null),0)
--SET @codrsa_gasto_rep = isnull(gen.get_valor_parametro_int ('CodigoRubroGastoRep',null,null,@codcia,null),0)

SET @codtpl_ordinario = isnull(gen.get_valor_parametro_int ('CodigoPlanillaQuincenal',null,null,@codcia,null),0)
SET @codtpl_decimo    = isnull(gen.get_valor_parametro_int ('CodigoPlanillaDecimo',null,null,@codcia,null),0)
--SET @codtpl_Vacaciones   = isnull(gen.get_valor_parametro_int ('PA_codtpl_vacaciones',null,null,@codcia,null),0)
--SET @codtpl_GtosRep      = isnull(gen.get_valor_parametro_int ('PA_codtpl_GtosRep',null,null,@codcia,null),0)
   
--SET @PERIODO_INI = CONVERT(DATETIME,'01/01/'+CONVERT(VARCHAR, @ANIO), 103)
SET @anio_fin = CONVERT(DATETIME,'31/12/'+CONVERT(VARCHAR, @anio), 103)

SET @quincenas_pendientes = CONVERT(INT, DATEDIFF(DD, @fecha_ini, @anio_fin) / 15)

select @decimos_pendientes = 4 - ppl_frecuencia
from sal.ppl_periodos_planilla
where ppl_codtpl = @codtpl_decimo
and @fecha_ini >= ppl_fecha_ini
and @fecha_ini <= ppl_fecha_fin

SET @periodos_restantes_calculo = @quincenas_pendientes --+ @decimos_pendientes * 2 / 3

INSERT INTO sal.rap_renta_anual_panama(
	rap_codcia,
	rap_codtpl,
	rap_codppl,
	rap_codemp,
	rap_acumulado,
	rap_retenido,
	rap_proyectado,
	rap_desc_legal,
	rap_periodos_restantes
)
SELECT @codcia codcia,
	   @codtpl codtpl,
	   @codppl codppl,
	   codemp,
	   pa.fn_agrupador_valores_periodo_isr2 (@codcia, codemp, @anio, @agr_base_isr) acumulado,
	   pa.fn_agrupador_valores_periodo_isr2 (@codcia, codemp, @anio, @agr_descuentos_isr) retenido,
	   CONVERT(NUMERIC(12, 2), ese_salario_quincenal * (CASE WHEN @quincenas_pendientes <= 0 THEN 0 ELSE (@quincenas_pendientes - ISNULL(dva_dias / 15, 1)) END)) proyectado,
	   (CASE codclr WHEN 'E' THEN @isr_deduccion_legal ELSE 0 END) deduccion_legal,
	   @periodos_restantes_calculo periodos_restantes_calculo
FROM (
	SELECT emp_codigo codemp,
		   ISNULL(gen.get_pb_field_data(exp_property_bag_data, 'exp_clase_renta'), 'A') codclr,
		   ese_salario_quincenal
	  FROM exp.emp_empleos
	  JOIN exp.exp_expedientes
	  ON exp_codigo = emp_codexp
	  JOIN (SELECT ese_codemp, CONVERT(NUMERIC(12,2), ese_valor / 2.00) ese_salario_quincenal
			FROM exp.ese_estructura_sal_empleos
			WHERE ese_estado = 'V'
			AND ese_codrsa = @codrsa
		) salarios
	  ON ese_codemp = emp_codigo
	  WHERE emp_codtpl = @codtpl_ordinario
	   AND emp_estado = 'A'
	   AND emp_fecha_ingreso <= @FECHA_FIN
) V
LEFT JOIN (
	SELECT vac_codemp, ISNULL(SUM(ISNULL(dva_dias, 0)), 0) dva_dias
	FROM acc.dva_dias_vacacion
	JOIN acc.vac_vacaciones
	ON vac_codigo = dva_codvac
	WHERE dva_codppl = @codppl
	GROUP BY vac_codemp
) vacaciones
ON vac_codemp = codemp
ORDER BY codemp

END

GO


