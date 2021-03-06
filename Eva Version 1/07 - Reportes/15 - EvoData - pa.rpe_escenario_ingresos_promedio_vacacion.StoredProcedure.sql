IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_escenario_ingresos_promedio_vacacion')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_escenario_ingresos_promedio_vacacion]
GO
/****** Object:  StoredProcedure [pa].[rpe_escenario_ingresos_promedio_vacacion]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [pa].[rpe_escenario_ingresos_promedio_vacacion]
	@codcia int, 
	--@codtpl INT = null, 
	--@codigo_planilla varchar(10), 
	--@codemp INT = null, 
	--@tipo_ingreso varchar(1) = null,
	@codexp_alternativo varchar(36),
	@dias_goce int,
	@pcodrsa int = null
as

set nocount on
set dateformat dmy

-- exec pa.rpe_ingresos_promedio_vacacion 1, 3, '20160902', null, 'S'

create table #tmp_fecha_ini_prom_vac (
   codemp int,
   fecha_ini datetime,
   tipo_ingreso varchar(1)
)

DECLARE @fecha_ini datetime, @fecha_fin datetime
declare @agr_ing_salario int, @codtpl_quincenal INT
declare @fecha_pago datetime, @fecha_fin_vac datetime, @fecha_ini_vac datetime, @estado_ppl_vac varchar(15)
declare @codtpl_vac int, @codppl int, @codrsa int, @codtpl int, @tipo_ingreso varchar(1), @codemp int

select @codtpl_quincenal = gen.get_valor_parametro_int ('CodigoPlanillaQuincenal',null,null,@codcia,null)
select @codtpl_vac = gen.get_valor_parametro_int ('CodigoPlanillaVacacion',null,null,@codcia,null)
select @codtpl = @codtpl_vac

select @codemp = emp_codigo
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
where exp_codigo_alternativo = @codexp_alternativo

-- Toma los datos de la planilla de vacaciones
--SELECT @fecha_fin_vac = ppl_fecha_fin, @codppl = ppl_codigo, @fecha_ini_vac = ppl_fecha_ini, @estado_ppl_vac = ppl_estado
--FROM sal.ppl_periodos_planilla
--WHERE ppl_codtpl = @codtpl
--AND ppl_codigo_planilla = @codigo_planilla

select @tipo_ingreso = convert(varchar(1), rsa_descripcion)
from exp.rsa_rubros_salariales
where rsa_codigo = @pcodrsa

select @agr_ing_salario = agr_codigo
from sal.agr_agrupadores
where agr_abreviatura = (case @tipo_ingreso when 'S' then 'IngresosVacacion' else 'IngresosVacacionGRep' end)

if @pcodrsa is null
begin
	select @codrsa = isnull(gen.get_valor_parametro_int ((case @tipo_ingreso when 'S' then 'CodigoRubroSalario' else 'CodigoRubroGastoRep' end),null,null,@codcia,null),0)
end
else
begin
	select @codrsa = @pcodrsa
end

-- Toma los datos de la ultima planilla autorizada
-- previo a la planilla de vacaciones para la cual se genera el reporte
SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN, @fecha_pago = PPL_FECHA_PAGO
FROM sal.ppl_periodos_planilla
WHERE ppl_codtpl = @codtpl_quincenal
AND ppl_estado = 'Autorizado'
--AND ppl_fecha_pago < @fecha_inicia_goce
ORDER BY ppl_fecha_pago asc

set @fecha_ini_vac = dateadd(dd, 1, @fecha_fin)

insert into #tmp_fecha_ini_prom_vac
SELECT @codemp, pa.fn_get_inicio_promedio_vacacion(@codcia, @tipo_ingreso, @codemp, @fecha_ini_vac), 'S'

create table #tmp (
	CIA_DES varchar(150),
	TPL_CODIGO int,
	TPL_DESCRIPCION varchar(50),
	PPL_CODPLA int,
	PPL_FECHA_INI DATETIME,
	PPL_FECHA_FIN DATETIME,
	PPL_FECHA_PAGO DATETIME,
	EMP_CODIGO VARCHAR(36),
	CODEXP_ALTERNATIVO VARCHAR(36),
	EMP_NOMBRES_APELLIDOS VARCHAR(107),
	EMP_SALARIO NUMERIC(12,2),
	UNI_CODIGO INT,
	UNI_NOMBRE VARCHAR(80),
	INN_VALOR NUMERIC(12,2),
	EMP_SALARIO_HORA NUMERIC(12,2),
	DIAS_VAC INT,
	PERIODO_VAC VARCHAR(9),
	FECHA_INI_VAC DATETIME,
	FECHA_FIN_VAC DATETIME,
	FECHA_INI_PERIODO DATETIME,
	FECHA_FIN_PERIODO DATETIME,
	TIPO_INGRESO VARCHAR(1)
)

INSERT INTO #tmp
SELECT cia_descripcion CIA_DES,
	   @codtpl TPL_CODIGO, 
	   TPL_DESCRIPCION,
	   PPL_CODPLA,
	   PPL_FECHA_INI,
	   PPL_FECHA_FIN,
	   PPL_FECHA_PAGO,
	   exp_codigo_alternativo EMP_CODIGO,
	   exp_codigo_alternativo CODEXP_ALTERNATIVO,
	   exp_nombres_apellidos EMP_NOMBRES_APELLIDOS,
	   ese_valor EMP_SALARIO,
	   UNI_CODIGO,
	   uni_descripcion UNI_NOMBRE,
	   INN_VALOR,
	   ese_valor_hora EMP_SALARIO_HORA,
	   @dias_goce DIAS_VAC,
	   'Periodo' PERIODO_VAC,
	   @fecha_ini_vac FECHA_INI_VAC,
	   dateadd(dd, @dias_goce - 1, @fecha_ini_vac) FECHA_FIN_VAC,
	   @fecha_ini FECHA_INI_PERIODO,
	   dateadd(dd, @dias_goce, @fecha_ini_vac) FECHA_FIN_PERIODO,
	    tipo_ingreso
FROM (
	SELECT tpl_codcia CODCIA, TPL_DESCRIPCION,
		   ppl_codigo_planilla PPL_CODPLA,
		   PPL_FECHA_INI,
		   PPL_FECHA_FIN,
		   PPL_FECHA_PAGO,
		   EMP_CODIGO CODEMP,
		   emp_codexp CODEXP,
		   INN_VALOR,
		   tipo_ingreso
	FROM (
		select inn_codppl, inn_codemp, SUM(inn_valor) inn_valor
		from (
			SELECT inn_codppl, inn_codemp, inn_codtig, inn_valor
			FROM sal.inn_ingresos
			WHERE inn_codtig IN (
			   SELECT iag_codtig
			   FROM sal.iag_ingresos_agrupador
			   WHERE iag_codagr = @agr_ing_salario -- Agrupador ingresos de salario
			   )
			AND inn_valor > 0
			union all
			SELECT dss_codppl, dss_codemp, dss_codtdc, dss_valor * -1.00
			FROM sal.dss_descuentos
			WHERE dss_codtdc IN (
			   SELECT dag_codtdc
			   FROM sal.dag_descuentos_agrupador
			   WHERE dag_codagr = @agr_ing_salario -- Agrupador ingresos de salario
			   )
			AND dss_valor > 0
			) detalle
		GROUP BY inn_codppl, inn_codemp
		) INN
	JOIN sal.ppl_periodos_planilla
	ON ppl_codigo = INN.inn_codppl
	JOIN exp.emp_empleos
	ON emp_codigo = INN.inn_codemp
	JOIN sal.tpl_tipo_planilla 
	ON tpl_codigo = ppl_codtpl
	JOIN #tmp_fecha_ini_prom_vac 
	ON codemp = emp_codigo
	WHERE ppl_estado = 'Autorizado'
	AND ppl_fecha_pago >= fecha_ini -- dbo.fn_get_fecha_ini_prom_vac(@codcia, @fecha_pago, EMP_CODIGO) -- DATEADD(MONTH, -11,@fecha_pago)
	AND ppl_fecha_pago <= @fecha_ini_vac--DATEADD(DAY,-1,@fecha_pago)
	AND tpl_codcia = @codcia
	AND tpl_codigo = @codtpl_quincenal
	AND inn_valor > 0
) V
JOIN exp.emp_empleos
on emp_codigo = CODEMP
JOIN exp.exp_expedientes
ON exp_codigo = emp_codexp
JOIN eor.cia_companias 
ON cia_codigo = CODCIA
JOIN eor.plz_plazas 
ON plz_codigo = emp_codplz
JOIN eor.uni_unidades 
ON uni_codigo = plz_coduni
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
where ese_codrsa = @codrsa
and ese_estado = 'V'
ORDER BY exp_codigo_alternativo, ppl_fecha_pago

SELECT DISTINCT 
	CIA_DES ,
	TPL_CODIGO ,
	TPL_DESCRIPCION ,
	PPL_CODPLA ,
	PPL_FECHA_INI ,
	PPL_FECHA_FIN ,
	PPL_FECHA_PAGO ,
	EMP_CODIGO ,
	EMP_NOMBRES_APELLIDOS ,
	EMP_SALARIO ,
	UNI_CODIGO ,
	UNI_NOMBRE ,
	INN_VALOR ,
	EMP_SALARIO_HORA ,
	DIAS_VAC ,
	PERIODO_VAC ,
	FECHA_INI_VAC ,
	FECHA_FIN_VAC ,
	FECHA_INI_PERIODO ,
	FECHA_FIN_PERIODO ,
	TIPO_INGRESO,
	right('0' + convert(varchar, day(fecha_ini_vac)), 2) + ' de ' + 
		gen.nombre_mes( month(fecha_ini_vac) ) + ' de ' +
		convert(varchar, year(fecha_ini_vac))
	FECHA_INI_VAC_TXT,
	right('0' + convert(varchar, day(dateadd(dd, 1, fecha_fin_vac))), 2) + ' de ' + 
		gen.nombre_mes( month(dateadd(dd, 1, fecha_fin_vac)) ) + ' de ' +
		convert(varchar, year(dateadd(dd, 1, fecha_fin_vac)))
	FECHA_FIN_VAC_TXT
FROM #tmp

DROP TABLE #tmp_fecha_ini_prom_vac

return


GO
