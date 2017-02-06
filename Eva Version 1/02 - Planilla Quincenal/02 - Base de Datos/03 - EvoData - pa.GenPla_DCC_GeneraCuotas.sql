
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_DCC_GeneraCuotas')
                    AND type IN ( N'P', N'PC' ) ) 
/****** Object:  StoredProcedure [pa].[GenPla_DCC_GeneraCuotas]    Script Date: 16-01-2017 9:19:39 AM ******/
DROP PROCEDURE [pa].[GenPla_DCC_GeneraCuotas]
GO

/****** Object:  StoredProcedure [pa].[GenPla_DCC_GeneraCuotas]    Script Date: 16-01-2017 9:19:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_DCC_GeneraCuotas]
	@sessionId VARCHAR(36) = NULL,
    @codppl INT,
    @userName VARCHAR(100) = NULL
AS
BEGIN

declare @codtpl int, @Frecuencia int , @FechaFin datetime, @mes int, @anio int, @codtpl_normal int, @codtpl_vac int, @codcia int, @dias_vac int

select @codtpl = ppl_codtpl,
	   @Frecuencia = ppl_frecuencia,
	   @FechaFin = ppl_fecha_fin,
	   @mes = ppl_mes,
	   @anio = ppl_anio,
	   @codtpl_normal = isnull(tpl_codtpl_normal,0),
	   @codcia = tpl_codcia
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
where ppl_codigo = @codppl

select @codtpl_vac = gen.get_valor_parametro_int ('PA_CodigoPlanillaVacacion',null,null,@codcia,null)

-- Tabla que contiene los codigos de empleos que
-- participan en la planilla que se esta generando
CREATE TABLE #epp_empleo_participa_planilla (
	epp_codemp int
)

INSERT INTO #epp_empleo_participa_planilla
SELECT distinct dcc_codemp
FROM sal.dcc_descuentos_ciclicos
WHERE (sal.empleado_en_gen_planilla(@sessionId, dcc_codemp) = 1)

-- Elimina de la tabla de cuotas las que corresponden a ese periodo de pago para regenerarlas   
delete from sal.cdc_cuotas_descuento_ciclico
where cdc_codppl = @codppl
--and cdc_coddcc in (select dcc_codigo from sal.dcc_descuentos_ciclicos (nolock) join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp)

-- primero los descuentos ciclicos que son indefinidos
insert into sal.cdc_cuotas_descuento_ciclico
(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
select dcc_codigo, dcc_proxima_cuota,@codppl,@FechaFin, 
case when dcc_usa_porcentaje = 1 then 0 else round(dcc_valor_cuota/dcc_divisor,2) end
	from sal.dcc_descuentos_ciclicos_v
	join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp
	where	(dcc_codtpl = @codtpl or dcc_codtpl = @codtpl_normal)
		and dcc_estado = 'Autorizado' 
		and dcc_activo = 1 
		and dcc_fecha_inicio_descuento <= @FechaFin
		and dcc_monto_indefinido = 1
		and (dcc_frecuencia_periodo_pla = @frecuencia or dcc_frecuencia_periodo_pla = 0)
		and dcc_usa_porcentaje = 0

if @codtpl = @codtpl_vac
begin
	-- primero los descuentos ciclicos que son indefinidos
	-- les genera una cuota adicional si paga vacacion por 30 dias
	insert into sal.cdc_cuotas_descuento_ciclico
	(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
	select dcc_codigo, dcc_proxima_cuota + 1,@codppl,@FechaFin, 
	case when dcc_usa_porcentaje = 1 then 0 else round(dcc_valor_cuota/dcc_divisor,2) end
		from sal.dcc_descuentos_ciclicos_v
		join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp
		where	(dcc_codtpl = @codtpl or dcc_codtpl = @codtpl_normal)
			and dcc_estado = 'Autorizado' 
			and dcc_activo = 1 
			and dcc_fecha_inicio_descuento <= @FechaFin
			and dcc_monto_indefinido = 1
			and (dcc_frecuencia_periodo_pla = @frecuencia or dcc_frecuencia_periodo_pla = 0)
			and dcc_usa_porcentaje = 0
			and exists (
				select vac_codemp, sum(dva_dias) dias
				from acc.dva_dias_vacacion
				join acc.vac_vacaciones
				on vac_codigo = dva_codvac
				where dva_codppl = @codppl
				and vac_codemp = dcc_codemp
				group by vac_codemp
				having sum(dva_dias) = 30
			)
end

-- primero los descuentos ciclicos que son indefinidos con cuota diferenciada
insert into sal.cdc_cuotas_descuento_ciclico
(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
select dcc_codigo, dcc_proxima_cuota,@codppl,@FechaFin, 
(case @Frecuencia when 1 then dcc_valor_cuota_primera_quincena when 2 then dcc_valor_cuota_segunda_quincena else 0.00 end)
	from sal.dcc_descuentos_ciclicos_v
	join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp
	where	(dcc_codtpl = @codtpl or dcc_codtpl = @codtpl_normal)
		and dcc_estado = 'Autorizado' 
		and dcc_activo = 1 
		and dcc_fecha_inicio_descuento <= @FechaFin
		and dcc_monto_indefinido = 1
		and (dcc_frecuencia_periodo_pla = @frecuencia or dcc_frecuencia_periodo_pla = 0)
		and dcc_usa_porcentaje = 1
		and (dcc_valor_cuota_primera_quincena + dcc_valor_cuota_segunda_quincena) > 0

if @codtpl = @codtpl_vac
begin
	-- primero los descuentos ciclicos que son indefinidos con cuota diferenciada
	-- les genera una cuota adicional si paga vacacion por 30 dias
	insert into sal.cdc_cuotas_descuento_ciclico
	(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
	select dcc_codigo, dcc_proxima_cuota + 1,@codppl,@FechaFin, 
	(case @Frecuencia when 1 then dcc_valor_cuota_segunda_quincena when 2 then dcc_valor_cuota_primera_quincena else 0.00 end)
		from sal.dcc_descuentos_ciclicos_v
		join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp
		where	(dcc_codtpl = @codtpl or dcc_codtpl = @codtpl_normal)
			and dcc_estado = 'Autorizado' 
			and dcc_activo = 1 
			and dcc_fecha_inicio_descuento <= @FechaFin
			and dcc_monto_indefinido = 1
			and (dcc_frecuencia_periodo_pla = @frecuencia or dcc_frecuencia_periodo_pla = 0)
			and dcc_usa_porcentaje = 1
			and (dcc_valor_cuota_primera_quincena + dcc_valor_cuota_segunda_quincena) > 0
			and exists (
				select vac_codemp, sum(dva_dias) dias
				from acc.dva_dias_vacacion
				join acc.vac_vacaciones
				on vac_codigo = dva_codvac
				where dva_codppl = @codppl
				and vac_codemp = dcc_codemp
				group by vac_codemp
				having sum(dva_dias) = 30
			)
end

-- Ciclicos definidos
insert into sal.cdc_cuotas_descuento_ciclico
(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
select dcc_codigo, dcc_proxima_cuota ,@codppl,@FechaFin, 
case when dcc_usa_porcentaje = 1 then 0 else case when dcc_saldo < round(dcc_valor_cuota/dcc_divisor,2) then dcc_saldo else  round(dcc_valor_cuota/dcc_divisor,2) end end
	from sal.dcc_descuentos_ciclicos_v
        join #epp_empleo_participa_planilla on epp_codemp = dcc_codemp
	where	(dcc_codtpl = @codtpl or dcc_codtpl = @codtpl_normal)
		and dcc_estado = 'Autorizado' 
		and dcc_activo = 1 
		and dcc_fecha_inicio_descuento <= @FechaFin
		and dcc_usa_porcentaje = 0
		and dcc_monto_indefinido = 0
		and dcc_saldo > 0 -- para que descuente el saldo como ultima cuota
		and dcc_proxima_cuota <= dcc_numero_cuotas
		and (dcc_frecuencia_periodo_pla = @frecuencia or dcc_frecuencia_periodo_pla = 0)		

IF @codtpl = @codtpl_vac
BEGIN
	-- Ciclicos definidos
	-- les genera una cuota adicional si paga vacacion por 30 dias
	INSERT INTO sal.cdc_cuotas_descuento_ciclico
	(cdc_coddcc,cdc_numero_cuota,cdc_codppl,cdc_fecha_descuento,cdc_valor_cobrado)
	SELECT dcc_codigo, dcc_proxima_cuota + 1 ,@codppl,@FechaFin, 
	CASE WHEN dcc_usa_porcentaje = 1 THEN 0 ELSE CASE WHEN dcc_saldo < ROUND(dcc_valor_cuota/dcc_divisor,2) THEN dcc_saldo ELSE  ROUND(dcc_valor_cuota/dcc_divisor,2) END END
		FROM sal.dcc_descuentos_ciclicos_v
			JOIN #epp_empleo_participa_planilla ON epp_codemp = dcc_codemp
		WHERE	(dcc_codtpl = @codtpl OR dcc_codtpl = @codtpl_normal)
			AND dcc_estado = 'Autorizado' 
			AND dcc_activo = 1 
			AND dcc_fecha_inicio_descuento <= @FechaFin
			AND dcc_usa_porcentaje = 0
			AND dcc_monto_indefinido = 0
			AND dcc_saldo > 0 -- para que descuente el saldo como ultima cuota
			AND (dcc_proxima_cuota + 1) <= dcc_numero_cuotas
			AND (dcc_frecuencia_periodo_pla = @frecuencia OR dcc_frecuencia_periodo_pla = 0)
			AND EXISTS (
				SELECT vac_codemp, SUM(dva_dias) dias
				FROM acc.dva_dias_vacacion
				JOIN acc.vac_vacaciones
				ON vac_codigo = dva_codvac
				WHERE dva_codppl = @codppl
				AND vac_codemp = dcc_codemp
				GROUP BY vac_codemp
				HAVING SUM(dva_dias) = 30
			)
END

IF @codtpl = @codtpl_vac
BEGIN
	DELETE FROM sal.cdc_cuotas_descuento_ciclico
	WHERE cdc_codppl = @codppl
	AND EXISTS (
		SELECT 1
		FROM acc.dva_dias_vacacion
		JOIN acc.vac_vacaciones
		ON vac_codigo = dva_codvac
		JOIN sal.dcc_descuentos_ciclicos
		ON dcc_codemp = vac_codemp
		WHERE dva_codppl = @codppl
		AND dcc_codigo = cdc_coddcc
		AND dva_pagadas = 1
	)
END

-- si la cuota es mensual y la planilla de otra frecuencia
-- se ajusta la cuota para que no descuente centavos de mas
UPDATE sal.cdc_cuotas_descuento_ciclico
	SET cdc_valor_cobrado =  dcc_valor_cuota - 
			ISNULL((SELECT SUM(cdc_valor_cobrado)
				FROM sal.cdc_cuotas_descuento_ciclico
				JOIN sal.ppl_periodos_planilla  ON ppl_codigo = cdc_codppl
				WHERE cdc_coddcc = dcc_codigo
				AND ppl_mes = @mes
				AND ppl_anio = @anio
				AND cdc_aplicado_planilla = 1),0)
FROM sal.dcc_descuentos_ciclicos_v
    JOIN #epp_empleo_participa_planilla ON epp_codemp = dcc_codemp  
WHERE	cdc_coddcc = dcc_codigo
		AND cdc_codppl = @codppl
		AND dcc_frecuencia_cuota = 'Mensual'
		AND @frecuencia = dcc_divisor
		AND dcc_divisor > 1
		AND ROUND(dcc_valor_cuota,2)%dcc_divisor <> 0

DROP TABLE #epp_empleo_participa_planilla

END

GO


