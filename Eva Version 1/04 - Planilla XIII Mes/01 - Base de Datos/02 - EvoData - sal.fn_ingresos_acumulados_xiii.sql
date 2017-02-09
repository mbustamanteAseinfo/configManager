SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE FUNCTION [sal].[fn_ingresos_acumulados_xiii]
	(@codcia int, @codtpl int, @codppl int, @coduni int, @codemp int, @rubro_salarial varchar(1))
RETURNS @tmp_ingresos_acumulados_xiii TABLE 
		(CODCIA int,
		 CODUNI int,
		 CODEMP int,
		 FECHA_INI_XIII datetime,
		 FECHA_FIN_XIII datetime,
		 MES1 numeric(12,2),
		 MES2 numeric(12,2),
		 MES3 numeric(12,2),
		 MES4 numeric(12,2),
		 MES5 numeric(12,2),
		 MES1_NOMBRE varchar(10),
		 MES2_NOMBRE varchar(10),
		 MES3_NOMBRE varchar(10),
		 MES4_NOMBRE varchar(10),
		 MES5_NOMBRE varchar(10),
		 ACUMULADO numeric(12,2),
		 XIII numeric(12,2),
		 DIAS numeric(12,2))
AS
BEGIN
-- select * from sal.fn_ingresos_acumulados_xiii (1, 2, 1, null, null, 'S')
declare @fecha_ini datetime, @fecha_fin datetime, @agr_ingresos int

declare @mes1_ini datetime, @mes1_fin datetime,
        @mes2_ini datetime, @mes2_fin datetime,
        @mes3_ini datetime, @mes3_fin datetime,
        @mes4_ini datetime, @mes4_fin datetime,
        @mes5_ini datetime, @mes5_fin datetime, @mes5_fin_gasto datetime

declare @mes1_nombre varchar(50), @mes2_nombre varchar(50),
        @mes3_nombre varchar(50), @mes4_nombre varchar(50),
        @mes5_nombre varchar(50)

declare @ppl_estado varchar(1)

declare @codtpl_xiii int, @AGR_XIII_PROYECTADO int, @AGR_XIII_GR_PROYECTADO int

select @AGR_XIII_PROYECTADO = gen.get_valor_parametro_int('BaseXIII_Salario_CodigoAgrupador', 'pa', null, null, null)
select @AGR_XIII_GR_PROYECTADO = gen.get_valor_parametro_int('BaseXIII_GastoRep_CodigoAgrupador', 'pa', null, null, null)

-- Tipo de planilla: Decimo Tercero
set @codtpl_xiii = isnull(gen.get_valor_parametro_int('CodigoPlanillaDecimo',null,null,@codcia,null), 2)

if @codtpl = @codtpl_xiii
begin
	-- Agrupador que contiene los ingresos utilizados para calcular el promedio
	set @agr_ingresos = (case @rubro_salarial when 'S' then @AGR_XIII_PROYECTADO when 'G' then @AGR_XIII_GR_PROYECTADO else 0 end)
	
	-- Toma el rango de fechas para el cual debe acumular los ingresos para el calculo del XII Mes
	SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN, @ppl_estado = PPL_ESTADO
	FROM sal.ppl_periodos_planilla
	WHERE ppl_codtpl = @codtpl
	and ppl_codigo = @codppl
	
	set @mes1_ini = @fecha_ini
	set @mes1_fin = DATEADD(DD, -1, CONVERT(VARCHAR, YEAR(DATEADD(mm, 1, @fecha_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(mm, 1, @fecha_ini))) + '-01')
	
	set @mes2_ini = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(DATEADD(MM, 1, @fecha_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 1, @fecha_ini))) + '-01')
	set @mes2_fin = DATEADD(DD, -1, CONVERT(VARCHAR, YEAR(DATEADD(MM, 1, @mes2_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 1, @mes2_ini))) + '-01')
	
	set @mes3_ini = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(DATEADD(MM, 2, @fecha_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 2, @fecha_ini))) + '-01')
	set @mes3_fin = DATEADD(DD, -1, CONVERT(VARCHAR, YEAR(DATEADD(MM, 1, @mes3_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 1, @mes3_ini))) + '-01')
	
	set @mes4_ini = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(DATEADD(MM, 3, @fecha_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 3, @fecha_ini))) + '-01')
	set @mes4_fin = DATEADD(DD, -1, CONVERT(VARCHAR, YEAR(DATEADD(MM, 1, @mes4_ini))) + '-' + CONVERT(VARCHAR, MONTH(DATEADD(MM, 1, @mes4_ini))) + '-01')
	
	set @mes5_ini = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(@fecha_fin)) + '-' + CONVERT(VARCHAR, MONTH(@fecha_fin)) + '-01')
	set @mes5_fin = @fecha_fin

	set @mes1_nombre = gen.fn_get_NombreMes(month(@mes1_ini))
	set @mes2_nombre = gen.fn_get_NombreMes(month(@mes2_ini))
	set @mes3_nombre = gen.fn_get_NombreMes(month(@mes3_ini))
	set @mes4_nombre = gen.fn_get_NombreMes(month(@mes4_ini))
	set @mes5_nombre = gen.fn_get_NombreMes(month(@mes5_ini))
	
	/*
	dic-mitad2
	ene
	feb
	mar
	abr-mitad1
	abr-mitad2
	may
	jun
	jul
	ago-mitad1
	ago-mitad2
	sep
	oct
	nov
	dic-mitad1
	*/
	
	INSERT INTO @tmp_ingresos_acumulados_xiii
	SELECT @codcia codcia,
		   CODUNI,
		   CODEMP,
		   @fecha_ini fecha_ini_xiii,
		   @fecha_fin fecha_fin_xiii,
		   mes1,
		   mes2,
		   mes3,
		   mes4,
		   mes5,
		   mes1_nombre,
		   mes2_nombre,
		   mes3_nombre,
		   mes4_nombre,
		   mes5_nombre,
		   mes1 + mes2 + mes3 + mes4 + mes5 ACUMULADO,
		   convert(numeric(12,2), (mes1 + mes2 + mes3 + mes4 + mes5) / 12.00) XIII,
		   DIAS = sal.fn_agrupador_dias_periodo(@codcia, CODEMP, @fecha_ini, @fecha_fin, @agr_ingresos)
	FROM (
		SELECT uni_codigo CODUNI, emp_codigo CODEMP, 
			   CONVERT(NUMERIC(12,2), (CASE @rubro_salarial WHEN 'S' THEN mes1 WHEN 'G' THEN mes1 ELSE 0 END)) mes1,
			   CONVERT(NUMERIC(12,2), mes2) mes2,
			   CONVERT(NUMERIC(12,2), mes3) mes3,
			   CONVERT(NUMERIC(12,2), mes4) mes4,
			   CONVERT(NUMERIC(12,2), (CASE @rubro_salarial WHEN 'S' THEN mes5 WHEN 'G' THEN mes5 ELSE 0 END)) mes5,
			   @mes1_nombre mes1_nombre,
			   @mes2_nombre mes2_nombre,
			   @mes3_nombre mes3_nombre,
			   @mes4_nombre mes4_nombre,
			   @mes5_nombre mes5_nombre
		FROM (
			SELECT uni_codigo, emp_codigo,
				   sal.fn_agrupador_valores_periodo(plz_codcia, emp_codigo, @mes1_ini, @mes1_fin, @agr_ingresos) +
				   sal.fn_salario_total_periodo_incap(plz_codcia, emp_codigo, @rubro_salarial, @mes1_ini, @mes1_fin, uni_codpai)
				   mes1,
				   sal.fn_agrupador_valores_periodo(plz_codcia, emp_codigo, @mes2_ini, @mes2_fin, @agr_ingresos) +
				   sal.fn_salario_total_periodo_incap(plz_codcia, emp_codigo, @rubro_salarial, @mes2_ini, @mes2_fin, uni_codpai)
				   mes2,
				   sal.fn_agrupador_valores_periodo(plz_codcia, emp_codigo, @mes3_ini, @mes3_fin, @agr_ingresos) +
				   sal.fn_salario_total_periodo_incap(plz_codcia, emp_codigo, @rubro_salarial, @mes3_ini, @mes3_fin, uni_codpai)
				   mes3,
				   sal.fn_agrupador_valores_periodo(plz_codcia, emp_codigo, @mes4_ini, @mes4_fin, @agr_ingresos) +
				   sal.fn_salario_total_periodo_incap(plz_codcia, emp_codigo, @rubro_salarial, @mes4_ini, @mes4_fin, uni_codpai)
				   mes4,
				   sal.fn_agrupador_valores_periodo(plz_codcia, emp_codigo, @mes5_ini, @mes5_fin, @agr_ingresos) +
				   sal.fn_salario_total_periodo_incap(plz_codcia, emp_codigo, @rubro_salarial, @mes5_ini, @mes5_fin, uni_codpai)
				   mes5
			FROM exp.emp_empleos (NOLOCK)
			JOIN eor.plz_plazas (NOLOCK)
			ON plz_codigo = emp_codplz
			JOIN eor.uni_unidades (NOLOCK)
			ON uni_codcia = plz_codcia
			AND uni_codigo = plz_coduni
			WHERE plz_codcia = @codcia
			AND (emp_estado = 'A' 
				-- Esta condicion permite recuperar los datos de los empleados retirados
				-- una vez que la planilla ha sido autorizada
				OR (@ppl_estado = 'Autorizado' AND EXISTS (SELECT * FROM sal.inn_ingresos WHERE inn_codppl = @codppl AND inn_codemp = emp_codigo)))
			AND uni_codigo = COALESCE(@coduni, uni_codigo)
			AND emp_codigo = COALESCE(@codemp, emp_codigo)
		) V
		WHERE mes1 + mes2 + mes3 + mes4 + mes5 > 0
	) W
end
else
begin
   INSERT INTO @tmp_ingresos_acumulados_xiii
	SELECT 0 codcia,
		   0 coduni,
		   0 codemp,
		   null fecha_ini_xiii,
		   null fecha_fin_xiii,
		   0 mes1,
		   0 mes2,
		   0 mes3,
		   0 mes4,
		   0 mes5,
		   '' mes1_nombre,
		   '' mes2_nombre,
		   '' mes3_nombre,
		   '' mes4_nombre,
		   '' mes5_nombre,
		   0 ACUMULADO,
		   0 XIII,
		   0 DIAS
   FROM eor.cia_companias
   WHERE 1 = 2
end
return

END
GO
