IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.proc_llena_issp')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE [pa].[proc_llena_issp]
GO
CREATE PROCEDURE [pa].[proc_llena_issp]
	@codcia INT,
	@anio INT,
	@mes INT
AS
BEGIN

set nocount on
set dateformat dmy

declare @fini datetime, @ffin datetime

-- Fechas inicial y final de mes
select @fini = convert(datetime, '01/' + CONVERT(varchar, @mes) + '/' + CONVERT(varchar, @anio))
select @ffin = DATEADD(dd, -1, DATEADD(mm, 1, @fini))

-- Se usarán familias para determinar qué código asignar a cada tipo de ingreso
declare @fam_03 int,
		@fam_73 int,
		@fam_74 int,
		@fam_75 int,
		@fam_81 int,
		@fam_otros_03 int,
		@fam_otros_73 int,
		@fam_XIII_03 int,
		@fam_XIII_73 int

select @fam_03 = 70,
	   @fam_73 = 71,
	   @fam_74 = 74,
	   @fam_75 = 73,
	   @fam_81 = 78,
	   @fam_otros_03 = 72,
	   @fam_otros_73 = null,
	   @fam_XIII_03 = 79,
	   @fam_XIII_73 = 80

declare	@codtpl_ajuste int,
		@codtpl_vacacion int,
		@codtpl_liq int

declare @codtdc_ss_03 int,
		@codtdc_ss_XIII_03 int,
		@codtdc_ss_73 int,
		@codtdc_ss_XIII_73 int,
		@codtdc_ss_74 int,
		@codtdc_ss_75 int,
		@codtdc_ss_81 int

declare	@codtdc_renta_03 int,
		@codtdc_renta_XIII_03 int,
		@codtdc_renta_73 int,
		@codtdc_renta_XIII_73 int,
		@codtdc_renta_74 int,
		@codtdc_renta_75 int,
		@codtdc_renta_81 int

select @codtpl_ajuste = 0,
	   @codtpl_vacacion = 0,
	   @codtpl_liq = 0

select @codtdc_ss_03 = 1,
	   @codtdc_ss_XIII_03 = 60,
	   @codtdc_ss_73 = 59,
	   @codtdc_ss_XIII_73 = null,
	   @codtdc_ss_74 = null,
	   @codtdc_ss_75 = null,
	   @codtdc_ss_81 = null

select @codtdc_renta_03 = 3,
	   @codtdc_renta_XIII_03 = null,
	   @codtdc_renta_73 = 4,
	   @codtdc_renta_XIII_73 = null,
	   @codtdc_renta_74 = null,
	   @codtdc_renta_75 = null,
	   @codtdc_renta_81 = null

/*
iss_codemp
iss_fecha
iss_anio
iss_mes
iss_codigo_rubro
iss_devengado
iss_aporte_empleado
iss_aporte_patronal
iss_decimo
iss_otros
iss_observaciones
*/

/*
03 salario
73 gasto representacion
74 gratificaciones y aguinaldos de navidad
75 bonificacion
80 dietas
81 prima productividad o produccion
82 salario en especie
84 combustible
85 excedente de bonificacion
*/

delete from pa.iss_seguro
where iss_codcia = @codcia
and iss_anio = @anio
and iss_mes = @mes

-- 03 SALARIO
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '03', @fam_03, @codtdc_renta_03, @codtdc_ss_03, @fam_otros_03, 0
-- 03 DECIMO TERCERO SALARIO
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '03', @fam_XIII_03, @codtdc_renta_XIII_03, @codtdc_ss_XIII_03, null, 1
-- 73 GASTO DE REPRESENTACION
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '73', @fam_73, @codtdc_renta_73, @codtdc_ss_73, null, 0
-- 73 DECIMO TERCERO GR
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '73', @fam_XIII_73, @codtdc_renta_XIII_73, @codtdc_ss_XIII_73, null, 1
-- 74 GRATIFICACIONES
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '74', @fam_74, @codtdc_renta_74, @codtdc_ss_74, null, 0
-- 75 BONO
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '75', @fam_75, @codtdc_renta_75, @codtdc_ss_75, null, 0
-- 81 PRIMA DE PRODUCCION
exec pa.proc_llena_iss_seguro @codcia, @anio, @mes, '81', @fam_81, @codtdc_renta_81, @codtdc_ss_81, null, 0

delete from pa.iss_seguro
where iss_codcia = @codcia
and iss_anio = @anio
and iss_mes = @mes
and iss_devengado = 0
and iss_renta = 0
and iss_aporte_empleado = 0
and iss_aporte_patronal = 0
and iss_otros = 0

-- Observaciones por Nuevo ingreso
update pa.iss_seguro
set iss_observaciones = coalesce(iss_observaciones, '') + 'Entró ' + CONVERT(varchar(10), emp_fecha_ingreso, 103) + '. '
from exp.emp_empleos
where emp_codigo = iss_codemp
and iss_anio = @anio
and iss_mes = @mes
and YEAR(emp_fecha_ingreso) = @anio
and month(emp_fecha_ingreso) = @mes
and iss_es_decimo = 0

-- Observaciones por Retiro de personal
UPDATE pa.iss_seguro
SET iss_observaciones = COALESCE(iss_observaciones, '') + 'Salió ' + CONVERT(VARCHAR(10), emp_fecha_retiro, 103) + '. '
FROM exp.emp_empleos
WHERE emp_codigo = iss_codemp
AND iss_anio = @anio
AND iss_mes = @mes
AND YEAR(emp_fecha_retiro) = @anio
AND MONTH(emp_fecha_retiro) = @mes
AND iss_es_decimo = 0

-- Observaciones por Personal en Incapacidad
UPDATE pa.iss_seguro
SET iss_observaciones = COALESCE(iss_observaciones, '') + 'Incapacidad'
FROM acc.ixe_incapacidades
JOIN acc.rin_riesgos_incapacidades
ON rin_codigo = ixe_codrin
WHERE ixe_codemp = iss_codemp
AND iss_anio = @anio
AND iss_mes = @mes
AND YEAR(ixe_inicio) = @anio
AND MONTH(ixe_inicio) = @mes
AND iss_es_decimo = 0
AND rin_utiliza_fondo = 1

-- Observaciones por Personal en Licencia
UPDATE pa.iss_seguro
SET iss_observaciones = COALESCE(iss_observaciones, '') + 'Licencia'
FROM acc.ixe_incapacidades
JOIN acc.rin_riesgos_incapacidades
ON rin_codigo = ixe_codrin
WHERE ixe_codemp = iss_codemp
AND iss_anio = @anio
AND iss_mes = @mes
AND YEAR(ixe_inicio) = @anio
AND MONTH(ixe_inicio) = @mes
AND iss_es_decimo = 0
AND rin_utiliza_fondo = 0

-- Observaciones por Personal con goce de vacaciones
UPDATE pa.iss_seguro
SET iss_observaciones = COALESCE(iss_observaciones, '') + 'Vacaciones'
FROM sal.inn_ingresos
JOIN sal.ppl_periodos_planilla
ON ppl_codigo = inn_codppl
WHERE ppl_codtpl = @codtpl_vacacion
AND ppl_anio = @anio
AND ppl_mes = @mes
AND inn_codemp = iss_codemp
AND ppl_anio = iss_anio
AND ppl_mes = iss_mes
AND ppl_estado = 'Autorizado'
AND iss_es_decimo = 0

-- select * from pa.iss_seguro

END
GO


