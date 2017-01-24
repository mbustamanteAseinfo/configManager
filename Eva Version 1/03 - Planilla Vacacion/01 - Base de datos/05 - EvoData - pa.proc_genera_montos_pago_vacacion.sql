IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.proc_genera_montos_pago_vacacion')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[proc_genera_montos_pago_vacacion]    Script Date: 16-01-2017 3:26:36 PM ******/
DROP PROCEDURE [pa].[proc_genera_montos_pago_vacacion]
GO

/****** Object:  StoredProcedure [pa].[proc_genera_montos_pago_vacacion]    Script Date: 16-01-2017 3:26:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[proc_genera_montos_pago_vacacion]
    @codppl INT,
    @tipo_ingreso VARCHAR(1)
AS
set nocount on
-- exec pa.proc_genera_montos_pago_vacacion 1149, 'S'
begin transaction
set dateformat dmy

declare @fecha_pago datetime,
		@agr_ing_salario int, 
		@codtpl_quincenal int, 
		@fecha_fin datetime,
		@codcia int,
		@codrsa int,
		@estado varchar(15),
		@fecha_ini_vac datetime

-- Toma la fecha final de la planilla de vacaciones
select @codcia = tpl_codcia,
	   @fecha_fin = ppl_fecha_fin,
	   @estado = ppl_estado,
	   @fecha_ini_vac = ppl_fecha_ini
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
where ppl_codigo = @codppl

IF @estado <> 'Autorizado'
BEGIN

	-- Elimina los datos que hayan sido generados previamente
	delete from pa.mpv_montos_pago_vacacion
	where mpv_codppl = @codppl
	and mpv_tipo_ingreso = @tipo_ingreso

	-- Elimina las fechas de inicio promedio vacaciones calculados previamente
	delete from pa.ipv_inicio_promedio_vacacion
	where ipv_codppl = @codppl
	and ipv_tipo_ingreso = @tipo_ingreso

	select @codtpl_quincenal = gen.get_valor_parametro_int ('CodigoPlanillaQuincenal',null,null,@codcia,null)

	select @agr_ing_salario = agr_codigo
	from sal.agr_agrupadores
	where agr_abreviatura = (case @tipo_ingreso when 'S' then 'IngresosVacacion' else 'IngresosVacacionGRep' end)

	select @codrsa = isnull(gen.get_valor_parametro_int ((case @tipo_ingreso when 'S' then 'CodigoRubroSalario' else 'CodigoRubroGastoRep' end),null,null,@codcia,null),0)

	-- Toma los datos de la ultima planilla autorizada
	-- previo a la planilla de vacaciones para la cual se genera el reporte
	SELECT @fecha_pago = ppl_fecha_fin
	FROM sal.ppl_periodos_planilla
	WHERE ppl_codtpl = @codtpl_quincenal
	AND ppl_estado = 'Autorizado'
	AND ppl_fecha_pago < @fecha_fin
	ORDER BY ppl_fecha_pago ASC

	-- Calcula las fechas a partir de las cuales debe tomar los acumulados para el calculo del promedio
	INSERT INTO pa.ipv_inicio_promedio_vacacion 
		(ipv_codppl,
		 ipv_tipo_ingreso,
		 ipv_codemp,
		 ipv_fecha_ini)
	SELECT DISTINCT
			@codppl codppl,
			@tipo_ingreso tipo_ingreso,
			vac_codemp codemp, 
			pa.fn_get_inicio_promedio_vacacion(@codcia, @tipo_ingreso, vac_codemp, @fecha_ini_vac) fecha_ini
	FROM acc.dva_dias_vacacion
	JOIN sal.ppl_periodos_planilla
	ON ppl_codigo = dva_codppl
	join acc.vac_vacaciones
	on vac_codigo = dva_codvac
	WHERE ppl_codigo = @codppl

	-- Genera los datos sin establecer el valor de MPV_PAGADO
	-- ya que este valor lo asigna la planilla
	INSERT INTO pa.mpv_montos_pago_vacacion (
		mpv_codppl,
		mpv_codemp,
		mpv_salario,
		mpv_promedio,
		mpv_pagado,
		mpv_pagadas,
		mpv_tipo_ingreso,
		mpv_dias
	)
	SELECT codppl,
		   codemp,
		   CONVERT(NUMERIC(12,2), salario / 30.00 * dias) salario,
		   CONVERT(NUMERIC(12,2), promedio / 30.00 * dias) promedio,
		   CONVERT(NUMERIC(12,2), (CASE WHEN salario > promedio THEN salario ELSE promedio END) / 30.00 * dias) pagado,
		   pagadas,
		   tipo_ingreso,
		   dias
	FROM (
		SELECT  @codppl codppl,
				codemp,
				ese_valor AS salario,
				promedio,
				COALESCE((SELECT TOP 1 dva_pagadas
						  FROM acc.dva_dias_vacacion 
						  JOIN acc.vac_vacaciones
						  ON vac_codigo = dva_codvac
						  WHERE dva_codppl = @codppl 
						  AND vac_codemp = codemp), '') 
				pagadas,
				@tipo_ingreso tipo_ingreso,
				COALESCE((SELECT SUM(dva_dias)
						  FROM acc.dva_dias_vacacion 
						  JOIN acc.vac_vacaciones
						  ON vac_codigo = dva_codvac
						  WHERE dva_codppl = @codppl 
						  AND vac_codemp = codemp), 0) 
				dias
		FROM (
			SELECT codemp, CONVERT(NUMERIC(12,2), ISNULL(SUM(ISNULL(monto,0)) ,0) / 11.00) promedio
			FROM (
				SELECT inn_codemp codemp, inn_valor monto
				FROM sal.inn_ingresos
				JOIN sal.ppl_periodos_planilla
				ON ppl_codigo = inn_codppl
				JOIN pa.ipv_inicio_promedio_vacacion
				ON ipv_codemp = inn_codemp
				WHERE ppl_estado = 'Autorizado'
				AND ppl_fecha_pago >= ipv_fecha_ini
				AND ppl_fecha_pago <= @fecha_pago -- DATEADD(DAY,-1,@fecha_ini)
				AND EXISTS (
					SELECT iag_codtig
					FROM sal.iag_ingresos_agrupador
					WHERE iag_codagr = @agr_ing_salario -- Agrupador ingresos de salario
					AND iag_codtig = inn_codtig
				)
				AND ppl_codtpl = @codtpl_quincenal
				AND ipv_codppl = @codppl
				AND ipv_tipo_ingreso = @tipo_ingreso
				UNION ALL
				SELECT dss_codemp codemp, dss_valor * -1.00 monto
				FROM sal.dss_descuentos
				JOIN sal.ppl_periodos_planilla
				ON ppl_codigo = dss_codppl
				JOIN pa.ipv_inicio_promedio_vacacion
				ON ipv_codemp = dss_codemp
				WHERE ppl_estado = 'Autorizado'
				AND ppl_fecha_pago >= ipv_fecha_ini
				AND ppl_fecha_pago <= @fecha_pago -- DATEADD(DAY,-1,@fecha_ini)
				AND EXISTS (
					SELECT dag_codtdc
					FROM sal.dag_descuentos_agrupador
					WHERE dag_codagr = @agr_ing_salario -- Agrupador ingresos de salario
					AND dag_codtdc = dss_codtdc
				)
				AND ppl_codtpl = @codtpl_quincenal
				AND ipv_codppl = @codppl
				AND ipv_tipo_ingreso = @tipo_ingreso
			) W
			GROUP BY CODEMP
		) V
		JOIN exp.ese_estructura_sal_empleos
		ON ese_codemp = codemp
		WHERE ese_codrsa = @codrsa
		AND ese_estado = 'V'
	) X

	-- Actualiza el numero de periodos de pago
	-- que se tomaron para el calculo del promedio
	UPDATE pa.mpv_montos_pago_vacacion
	SET mpv_num_periodos = (
			SELECT COUNT(DISTINCT CONVERT(VARCHAR, YEAR(ppl_fecha_pago)) + CONVERT(VARCHAR, MONTH(ppl_fecha_pago)))
			FROM sal.inn_ingresos
			JOIN sal.ppl_periodos_planilla
			ON ppl_codigo = inn_codppl
			JOIN pa.ipv_inicio_promedio_vacacion
			ON ipv_codemp = inn_codemp
			WHERE ppl_estado = 'Autorizado'
			AND ppl_fecha_pago >= ipv_fecha_ini
			AND ppl_fecha_pago <= @fecha_ini_vac
			AND ppl_codtpl = @codtpl_quincenal
			AND inn_codemp = mpv_codemp
			AND inn_valor > 0
			AND EXISTS (
				SELECT iag_codtig
				FROM sal.iag_ingresos_agrupador
				WHERE iag_codagr = @agr_ing_salario -- Agrupador ingresos de salario
				AND iag_codtig = inn_codtig
			)
			AND ipv_tipo_ingreso = @tipo_ingreso
			)
	WHERE mpv_codppl = @codppl
END

COMMIT TRANSACTION
RETURN

GO


