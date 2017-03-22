IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_genera_partida_contable')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_genera_partida_contable]    Script Date: 16-01-2017 2:18:17 PM ******/
DROP PROCEDURE [pa].[GenPla_genera_partida_contable]
GO

/****** Object:  StoredProcedure [pa].[GenPla_genera_partida_contable]    Script Date: 16-01-2017 2:18:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_genera_partida_contable]
	@codcia INT = NULL,
	@anio INT = NULL,
	@mes INT = NULL,
	@codtpl INT = NULL,
	@codigo_planilla VARCHAR(10) = NULL,
	@codppl INT = NULL
AS
BEGIN

declare @codppl_proceso int, @fetch int

-- set @codppl = 1014

IF @codtpl IS NOT NULL OR @codigo_planilla IS NOT NULL OR @anio IS NOT NULL OR @mes IS NOT NULL OR @codppl IS NOT NULL
BEGIN
	declare cur_ppl cursor
	for
	select ppl_codigo
	from sal.ppl_periodos_planilla
	join sal.tpl_tipo_planilla
	on tpl_codigo = ppl_codtpl
	where tpl_codcia = @codcia
	and tpl_codigo = isnull(@codtpl, tpl_codigo)
	and ppl_codigo_planilla = isnull(@codigo_planilla, ppl_codigo_planilla)
	and ppl_anio = isnull(@anio, ppl_anio)
	and ppl_mes = isnull(@mes, ppl_mes)
	and ppl_codigo = isnull(@codppl, ppl_codigo)

	open cur_ppl
	fetch cur_ppl into @codppl_proceso
	set @fetch = @@FETCH_STATUS

	WHILE @fetch = 0
	BEGIN
		delete from pa.dco_datos_contables
		where dco_codppl = @codppl_proceso

		INSERT INTO pa.dco_datos_contables
			(dco_codcia,
			 dco_codtpl, 
			 dco_codppl, 
			 dco_tipo_partida, 
			 dco_grupo, 
			 dco_centro_costo, 
			 dco_linea, 
			 dco_mes, 
			 dco_anio, 
			 dco_cta_contable, 
			 dco_descripcion, 
			 dco_debitos, 
			 dco_creditos, 
			 dco_codemp)
		SELECT tpl_codcia AS codcia,
			   tpl_codigo AS codtpl,
			   hpa_codppl,
			   tipo_partida,
			   NULL AS grupo,
			   (CASE WHEN (credito > 0 OR cuenta LIKE '0002%') AND cuenta NOT IN ( '0006101000', '0006101047' ) THEN NULL ELSE hpa_cco_nomenclatura_contable END) centro_costo,
			   NULL AS linea,
			   ppl_mes AS mes,
			   ppl_anio AS anio,
			   cuenta cta_contable,
			   concepto descripcion,
			   debito AS debitos,
			   credito AS creditos,
			   hpa_codemp AS codemp
		FROM sal.hpa_hist_periodos_planilla
		JOIN sal.ppl_periodos_planilla
		ON ppl_codigo = hpa_codppl
		JOIN sal.tpl_tipo_planilla
		ON tpl_codigo = ppl_codtpl
		JOIN (
			SELECT 'G' AS tipo_partida, inn_codppl codppl, inn_codemp codemp, tig_descripcion concepto, tig_cuenta cuenta, SUM(inn_valor) AS debito, 0.00 AS credito
			FROM sal.inn_ingresos
			JOIN sal.tig_tipos_ingreso
			ON tig_codigo = inn_codtig
			WHERE inn_codppl = @codppl_proceso
			GROUP BY inn_codppl, inn_codemp, tig_descripcion, tig_cuenta
			UNION
			SELECT 'G' AS tipo_partida, dss_codppl, dss_codemp, tdc_descripcion, tdc_cuenta, 0.00 AS debito, SUM(dss_valor) AS credito
			FROM sal.dss_descuentos
			JOIN sal.tdc_tipos_descuento
			ON tdc_codigo = dss_codtdc
			WHERE dss_codppl = @codppl_proceso
			GROUP BY dss_codppl, dss_codemp, tdc_descripcion, tdc_cuenta
			UNION
			SELECT 'G' AS tipo_partida, net_codppl, net_codemp, trs_descripcion descripcion, trs_cuenta cuenta, 0.00 AS debito, net_valor AS credito
			FROM sal.vis_inn_dss_neto
			JOIN sal.tpl_tipo_planilla
			ON tpl_codigo = net_codtpl
			JOIN sal.trs_tipos_reserva
			ON trs_codcia = tpl_codcia
			AND trs_codigo = (select trs_codigo from sal.trs_tipos_reserva where trs_abreviatura = '1') -- Ingreso Neto
			AND tpl_codigo NOT IN (select tpl_codigo from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon = 'PAB') -- Vacaciones
			WHERE net_codppl = @codppl_proceso
			UNION
			SELECT 'G' AS tipo_partida, net_codppl, net_codemp, trs_descripcion descripcion, trs_cuenta cuenta, 0.00 AS debito, net_valor AS credito
			FROM sal.vis_inn_dss_neto
			JOIN sal.tpl_tipo_planilla
			ON tpl_codigo = net_codtpl
			JOIN sal.trs_tipos_reserva
			ON trs_codcia = tpl_codcia
			AND trs_codigo = (select trs_codigo from sal.trs_tipos_reserva where trs_abreviatura = 'PROV_VAC') -- Provision vacaciones
			AND tpl_codigo IN (select tpl_codigo from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon = 'PAB') -- Vacaciones
			WHERE net_codppl = @codppl_proceso
			UNION
			SELECT 'P' AS tipo_partida, res_codppl, res_codemp, trs_descripcion descripcion, trs_cuenta cuenta, SUM(res_valor) AS debito, 0.00 AS credito
			FROM sal.res_reservas
			JOIN sal.trs_tipos_reserva
			ON trs_codigo = res_codtrs
			WHERE res_codppl = @codppl_proceso
			AND res_codtrs IN ((select trs_codigo from sal.trs_tipos_reserva where (trs_abreviatura = 'PROV_SEPatronal' or trs_abreviatura = 'PROV_SSPatronal') AND trs_codcia = @codcia))
			GROUP BY res_codppl, res_codemp, trs_descripcion, trs_cuenta
			UNION
			SELECT 'P' AS tipo_partida, res_codppl, res_codemp, trs_descripcion descripcion, trs_cuenta_patronal cuenta, 0.00 AS debito, SUM(res_valor) AS credito
			FROM sal.res_reservas
			JOIN sal.trs_tipos_reserva
			ON trs_codigo = res_codtrs
			WHERE res_codppl = @codppl_proceso
			AND res_codtrs IN ((select trs_codigo from sal.trs_tipos_reserva where (trs_abreviatura = 'PROV_SEPatronal' or trs_abreviatura = 'PROV_SSPatronal') AND trs_codcia = @codcia))
			GROUP BY res_codppl, res_codemp, trs_descripcion, trs_cuenta_patronal
			UNION
			SELECT 'R' AS tipo_partida, res_codppl, res_codemp, trs_descripcion descripcion, trs_cuenta cuenta, SUM(res_valor) AS debito, 0.00 AS credito
			FROM sal.res_reservas
			JOIN sal.trs_tipos_reserva
			ON trs_codigo = res_codtrs
			WHERE res_codppl = @codppl_proceso
			AND res_codtrs IN ((select trs_codigo from sal.trs_tipos_reserva where (trs_abreviatura = 'PROV_VAC' or trs_abreviatura = 'PROV_XIII' or trs_abreviatura = 'PROV_INDEM' or trs_abreviatura = 'PROV_Prima_Anti') AND trs_codcia = @codcia))
			GROUP BY res_codppl, res_codemp, trs_descripcion, trs_cuenta
			UNION
			SELECT 'R' AS tipo_partida, res_codppl, res_codemp, trs_descripcion descripcion, trs_cuenta_patronal cuenta, 0.00 AS debito, SUM(res_valor) AS credito
			FROM sal.res_reservas
			JOIN sal.trs_tipos_reserva
			ON trs_codigo = res_codtrs
			WHERE res_codppl = @codppl_proceso
			AND res_codtrs IN ((select trs_codigo from sal.trs_tipos_reserva where (trs_abreviatura = 'PROV_VAC' or trs_abreviatura = 'PROV_XIII' or trs_abreviatura = 'PROV_INDEM' or trs_abreviatura = 'PROV_Prima_Anti') AND trs_codcia = @codcia))
			GROUP BY res_codppl, res_codemp, trs_descripcion, trs_cuenta_patronal
		) planilla
		ON codppl = ppl_codigo
		AND codemp = hpa_codemp
		WHERE hpa_codppl = @codppl_proceso

		FETCH cur_ppl INTO @codppl_proceso
		SET @fetch = @@FETCH_STATUS
	END
END

END


GO


