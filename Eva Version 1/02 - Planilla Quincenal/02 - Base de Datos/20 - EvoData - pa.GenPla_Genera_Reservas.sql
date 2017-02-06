USE [EvoData]
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Genera_Reservas')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_Genera_Reservas]    Script Date: 16-01-2017 1:45:40 PM ******/
DROP PROCEDURE [pa].[GenPla_Genera_Reservas]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Genera_Reservas]    Script Date: 16-01-2017 1:45:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Genera_Reservas](
    @codcia INT = NULL,
	@anio INT = NULL,
	@mes INT = NULL,
	@codtpl INT = NULL,
	@codigo_planilla VARCHAR(10) = NULL,
	@sessionId VARCHAR(36) = NULL,
    @codppl INT = NULL,
    @userName VARCHAR(100) = NULL
)
AS
set nocount on

declare @isss_por_desc_pat real,
		@isss_por_desc_pat_xiii real,
		@seg_educativo_por_pat real,
		@por_provision_indemnizacion real,
		@por_provision_prima_antiguedad real,
		@por_provision_vacacion real,
		@por_provision_xiii_mes real,
		@por_riesgo_prof real

declare @codtag_isss int,
		@codtag_seg_educativo int,
		@codtag_indemnizacion int,
		@codtag_prima_ant int,
		@codtag_vacacion int,
		@codtag_xiii_mes int,
		@codtag_riesgo_prof int,
		@codtag_isss_xiii int

declare @codtrs_isss int,
		@codtrs_seg_educativo int,
		@codtrs_indemnizacion int,
		@codtrs_prima_antiguedad int,
		@codtrs_vacacion int,
		@codtrs_xiii_mes int,
		@codtrs_riesgo_prof int,
		@codpai varchar(2),
		@codmon varchar(3)

set @codpai = 'pa'

-- Asigna el codigo de moneda a utilizar
select @codmon = max(tpl_codmon)
from sal.tpl_tipo_planilla 
join sal.ppl_periodos_planilla on ppl_codtpl = tpl_codigo
where tpl_codcia = @codcia
and ppl_codtpl = isnull(@codtpl, ppl_codtpl)
and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
and ppl_anio = isnull(@anio, ppl_anio)
and ppl_mes = isnull(@mes, ppl_mes)
and ppl_codigo = isnull(@codppl, ppl_codigo)

-- Asigna los agrupadores de los ingresos para el calculo de las reservas
select @codtag_isss = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaSS'--883
select @codtag_isss_xiii = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaSSXIII'--889
select @codtag_seg_educativo = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaSE'--890
select @codtag_indemnizacion = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaIndem'--884
select @codtag_prima_ant = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaPrima'--885
select @codtag_vacacion = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaVac'--886
select @codtag_xiii_mes = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaXIII'--887
select @codtag_riesgo_prof = agr_codigo from sal.agr_agrupadores where agr_codpai=@codpai and agr_abreviatura='BaseCalculoReservaRiesgo'--888

-- Asigna los codigos de los tipos de reservas
select @codtrs_isss = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_SSPatronal_PA' and trs_codcia=@codcia   
select @codtrs_seg_educativo = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_SEPatronal_PA' and trs_codcia=@codcia
select @codtrs_indemnizacion = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_INDEM_PA' and trs_codcia=@codcia
select @codtrs_prima_antiguedad = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_Prima_Anti_PA' and trs_codcia=@codcia
select @codtrs_vacacion = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_VAC_PA' and trs_codcia=@codcia
select @codtrs_xiii_mes = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_XIII_PA' and trs_codcia=@codcia
select @codtrs_riesgo_prof = trs_codigo from sal.trs_tipos_reserva where trs_abreviatura='PROV_Riesgo_PA' and trs_codcia=@codcia

-- Recupera los porcentajes de las provisiones
SELECT	@isss_por_desc_pat = COALESCE(gen.get_valor_parametro_money('PA_CuotaPatronoSeguroSocial',@codpai,null,null,null), 0), --CuotaPatronoSeguroSocial
		@isss_por_desc_pat_xiii = COALESCE(gen.get_valor_parametro_money('PA_CuotaPatronoSeguroSocialXIII',@codpai,null,null,null), 0), --CuotaPatronoSeguroSocialXIII
		@seg_educativo_por_pat = COALESCE(gen.get_valor_parametro_money('PA_CuotaPatronoSeguroEducativo',@codpai,null,null,null), 0), --CuotaPatronoSeguroEducativo
		@por_provision_indemnizacion = COALESCE(gen.get_valor_parametro_money('PA_ProvisionIndemnizacion',@codpai,null,null,null), 0), --ProvisionIndemnizacion
		@por_provision_prima_antiguedad = COALESCE(gen.get_valor_parametro_money('PA_ProvisionPrimaAntiguedad',@codpai,null,null,null), 0), --ProvisionPrimaAntiguedad
		@por_provision_vacacion = COALESCE(gen.get_valor_parametro_money('PA_ProvisionVacacion',@codpai,null,null,null), 0),--ProvisionVacacion
		@por_provision_xiii_mes = COALESCE(gen.get_valor_parametro_money('PA_ProvisionXIIIMes',@codpai,null,null,null), 0),--ProvisionXIIIMes
		@por_riesgo_prof = COALESCE(gen.get_valor_parametro_money('PA_CuotaPatronoRiesgoProfesional',@codpai,null,null,null), 0)--CuotaPatronoRiesgoProfesional


-- Elimina las reservas
DELETE FROM sal.res_reservas
FROM sal.res_reservas
JOIN sal.ppl_periodos_planilla ON ppl_codigo = res_codppl
JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
and ppl_anio = isnull(@anio, ppl_anio)
and ppl_mes = isnull(@mes, ppl_mes)
AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
AND res_codtrs 
IN (@codtrs_isss,
	@codtrs_seg_educativo,
	@codtrs_indemnizacion,
	@codtrs_prima_antiguedad,
	@codtrs_vacacion,
	@codtrs_xiii_mes,
	@codtrs_riesgo_prof)

-- Reservas de Seguro Social
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_isss CODTRS, SUM(CONVERT(NUMERIC(12,2), VALOR * (CASE TIPO WHEN 'S' THEN @isss_por_desc_pat ELSE @isss_por_desc_pat_xiii END) / 100.00)) VALOR, @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, TIPO, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, 'S' TIPO, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND inn_codppl = COALESCE(@codppl, inn_codppl)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso on tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_isss)
		GROUP BY PPL_CODTPL, PPL_CODIGO, INN_CODEMP
		UNION
		SELECT PPL_CODTPL, ppl_codigo, DSS_CODEMP, 'S' TIPO, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = PPL_CODTPL
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND dss_codppl = COALESCE(@codppl, dss_codppl)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_isss)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
		UNION
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, 'D' TIPO, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND inn_codppl = COALESCE(@codppl, inn_codppl)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_isss_xiii)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL, ppl_codigo, DSS_CODEMP, 'D' TIPO, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND dss_codppl = COALESCE(@codppl, dss_codppl)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_isss_xiii)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
		) W
	GROUP BY CODTPL, CODPPL, CODEMP, TIPO
) V
GROUP BY CODTPL, CODPPL, CODEMP

-- Reservas de Seguro Educativo
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_seg_educativo, CONVERT(NUMERIC(12,2), VALOR * @seg_educativo_por_pat / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND inn_codppl = COALESCE(@codppl, inn_codppl)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_seg_educativo)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL, ppl_codigo, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND dss_codppl = COALESCE(@codppl, dss_codppl)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_seg_educativo)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

-- Reservas de Indemnización
INSERT INTO sal.res_reservas(res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_indemnizacion, CONVERT(NUMERIC(12,2), VALOR * @por_provision_indemnizacion / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND inn_codppl = COALESCE(@codppl, inn_codppl)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_indemnizacion)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL, ppl_codigo, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND dss_codppl = COALESCE(@codppl, dss_codppl)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_indemnizacion)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

-- Reservas de Prima de Antiguedad
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_prima_antiguedad, CONVERT(NUMERIC(12,2), VALOR * @por_provision_prima_antiguedad / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_prima_ant)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL, ppl_codigo, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_prima_ant)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

-- Reservas de Vacacion
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_vacacion, CONVERT(NUMERIC(12,2), VALOR * @por_provision_vacacion / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_vacacion)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPLA, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
		and ppl_anio = isnull(@anio, ppl_anio)
		and ppl_mes = isnull(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento on tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_vacacion)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

-- Reservas de XIII Mes
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_xiii_mes, CONVERT(NUMERIC(12,2), VALOR * @por_provision_xiii_mes / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		AND ppl_codigo_planilla = ISNULL(@codigo_planilla, ppl_codigo_planilla)
		AND ppl_anio = ISNULL(@anio, ppl_anio)
		AND ppl_mes = ISNULL(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_xiii_mes)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPLA, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		AND ppl_codigo_planilla = ISNULL(@codigo_planilla, ppl_codigo_planilla)
		AND ppl_anio = ISNULL(@anio, ppl_anio)
		AND ppl_mes = ISNULL(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento ON tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_xiii_mes)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

-- Reservas de Riesgo Profesional
INSERT INTO sal.res_reservas (res_codppl,res_codemp,res_codtrs,res_valor,res_codmon,res_tiempo)
SELECT CODPPL, CODEMP, @codtrs_riesgo_prof, CONVERT(NUMERIC(12,2), VALOR * @por_riesgo_prof / 100.00), @codmon CODMON, 0 TIEMPO
FROM (
	SELECT CODTPL, CODPPL, CODEMP, SUM(VALOR) VALOR
	FROM (
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, INN_CODEMP CODEMP, COALESCE(SUM(INN_VALOR), 0) VALOR
		FROM sal.inn_ingresos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = inn_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		AND ppl_codigo_planilla = ISNULL(@codigo_planilla, ppl_codigo_planilla)
		AND ppl_anio = ISNULL(@anio, ppl_anio)
		AND ppl_mes = ISNULL(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND INN_CODTIG 
		IN (SELECT iag_codtig
			FROM sal.iag_ingresos_agrupador
			JOIN sal.tig_tipos_ingreso ON tig_codigo = iag_codtig
			WHERE tig_codcia = @codcia
			AND iag_codagr = @codtag_riesgo_prof)
		GROUP BY PPL_CODTPL, ppl_codigo, INN_CODEMP
		UNION
		SELECT PPL_CODTPL CODTPL, ppl_codigo CODPPL, DSS_CODEMP, COALESCE(SUM(DSS_VALOR), 0) * -1
		FROM sal.dss_descuentos
		JOIN sal.ppl_periodos_planilla ON ppl_codigo = dss_codppl
		JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
		WHERE tpl_codcia = @codcia
		AND ppl_codtpl = COALESCE(@codtpl, ppl_codtpl)
		AND ppl_codigo_planilla = ISNULL(@codigo_planilla, ppl_codigo_planilla)
		AND ppl_anio = ISNULL(@anio, ppl_anio)
		AND ppl_mes = ISNULL(@mes, ppl_mes)
		AND ppl_codigo = COALESCE(@codppl, ppl_codigo)
		AND DSS_CODTDC
		IN (SELECT dag_codtdc
			FROM sal.dag_descuentos_agrupador
			JOIN sal.tdc_tipos_descuento ON tdc_codigo = dag_codtdc
			WHERE tdc_codcia = @codcia
			AND dag_codagr = @codtag_riesgo_prof)
		GROUP BY PPL_CODTPL, ppl_codigo, DSS_CODEMP
	) W
	GROUP BY CODTPL, CODPPL, CODEMP
) V

GO


