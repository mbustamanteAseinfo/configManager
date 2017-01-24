IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.fn_get_inicio_promedio_vacacion')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 

/****** Object:  UserDefinedFunction [pa].[fn_get_inicio_promedio_vacacion]    Script Date: 16-01-2017 3:30:08 PM ******/
DROP FUNCTION [pa].[fn_get_inicio_promedio_vacacion]
GO

/****** Object:  UserDefinedFunction [pa].[fn_get_inicio_promedio_vacacion]    Script Date: 16-01-2017 3:30:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [pa].[fn_get_inicio_promedio_vacacion](
	@codcia INT, 
    @tipo_ingreso VARCHAR(1),
    @codemp INT,
	@fecha_fin DATETIME
)
RETURNS DATETIME
AS
BEGIN

declare @fecha_ini datetime, @codtpl_pago int, @num_meses numeric(12,2), @num_meses_vac int, @continuar smallint, @fecha_ingreso datetime,
		@agr_ing_salario int

set @codtpl_pago = gen.get_valor_parametro_int ('CodigoPlanillaQuincenal',null,null,@codcia,null)

select @agr_ing_salario = agr_codigo
from sal.agr_agrupadores
where agr_abreviatura = (case @tipo_ingreso when 'S' then 'IngresosVacacion' else 'IngresosVacacionGRep' end)

select @fecha_ingreso = emp_fecha_ingreso
from exp.emp_empleos
where emp_codigo = @codemp

set @num_meses_vac = 11

select @fecha_ini = dateadd(mm, -11, @fecha_fin)

set @continuar = 1
WHILE @continuar = 1 --@num_meses <> @num_meses_vac
BEGIN

	-- Toma el numero de meses en los que se ha recibido pago en planilla
	SELECT @num_meses = COALESCE(COUNT(DISTINCT CONVERT(VARCHAR, YEAR(PPL_FECHA_PAGO)) + CONVERT(VARCHAR, MONTH(PPL_FECHA_PAGO))), 0)
	FROM sal.ppl_periodos_planilla
	JOIN sal.inn_ingresos
	ON inn_codppl = ppl_codigo
	WHERE ppl_estado = 'Autorizado'
	AND ppl_fecha_pago >=  @fecha_ini
	AND ppl_fecha_pago <= @fecha_fin
	AND ppl_codtpl = @codtpl_pago
	AND inn_codemp = @codemp
	AND inn_valor > 0
	AND inn_codtig IN (SELECT iag_codtig FROM sal.iag_ingresos_agrupador WHERE iag_codagr = @agr_ing_salario)
	--print 'num_meses: ' + convert(varchar, @num_meses)
	
	SELECT @num_meses = @num_meses - ISNULL(SUM(cuenta), 0) / 2.00 -- Hace los meses uno solo
	FROM (
		-- Toma los meses en los que ha tenido un solo pago de planilla
		SELECT CONVERT(VARCHAR, YEAR(ppl_fecha_pago)) + CONVERT(VARCHAR, MONTH(ppl_fecha_pago)) anio_mes, COUNT(DISTINCT ppl_codigo_planilla) cuenta
		FROM sal.ppl_periodos_planilla
		JOIN sal.inn_ingresos
		ON inn_codppl = ppl_codigo
		WHERE ppl_estado = 'Autorizado'
		AND ppl_fecha_pago >=  @fecha_ini
		AND ppl_fecha_pago <= @fecha_fin
		AND ppl_codtpl = @codtpl_pago
		AND inn_codemp = @codemp
		AND inn_valor > 0
		AND inn_codtig IN (SELECT iag_codtig FROM sal.iag_ingresos_agrupador WHERE iag_codagr = @agr_ing_salario)
		GROUP BY CONVERT(VARCHAR, YEAR(ppl_fecha_pago)) + CONVERT(VARCHAR, MONTH(ppl_fecha_pago))
		HAVING COUNT(DISTINCT ppl_codigo_planilla) = 1
	) v
	WHERE cuenta > 0
	--print 'num_meses: ' + convert(varchar, @num_meses)

	-- calcula la fecha inicial para el promedio de vacaciones
	SELECT @fecha_ini = DATEADD(dd, (@num_meses - @num_meses_vac) * 30, @fecha_ini)
	--print 'fecha_ini: ' + convert(varchar, @fecha_ini, 103)

	IF @num_meses = @num_meses_vac OR @fecha_ini <= @fecha_ingreso SET @continuar = 0
END

RETURN ISNULL(@fecha_ini, 0)

END


GO


