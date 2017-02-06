IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_INC_GeneraPeriodosIncapacidad')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_INC_GeneraPeriodosIncapacidad]    Script Date: 16-01-2017 9:45:27 AM ******/
DROP PROCEDURE [pa].[GenPla_INC_GeneraPeriodosIncapacidad]
GO

/****** Object:  StoredProcedure [pa].[GenPla_INC_GeneraPeriodosIncapacidad]    Script Date: 16-01-2017 9:45:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_INC_GeneraPeriodosIncapacidad](
	@sessionId VARCHAR(36) = NULL,
    @codppl INT,
    @userName VARCHAR(100) = NULL
)
AS

set nocount on

declare @codemp int, @horas_derecho_incap real,
		@horas_incapacidad real, @fecha_ppl datetime, @fetch_emp int,
		@ixe_numero int, @ixe_inicio datetime, @ixe_final datetime, @ixe_dias real, @ixe_horas real,
		@horas_incap_pagar real, @horas_incap_descontar real, @salario_hora real

declare @codpai varchar(2),
		@codcia int,
		@codfin int

SELECT @fecha_ppl = PPL_FECHA_FIN,
	@codcia = tpl_codcia,
	@codpai = cia_codpai
FROM sal.ppl_periodos_planilla (nolock)
JOIN sal.tpl_tipo_planilla (nolock) 
ON tpl_codigo = ppl_codtpl
JOIN eor.cia_companias (nolock)
on cia_codigo = tpl_codcia
WHERE ppl_codigo = @codppl

-- Tabla que contiene los codigos de empleos que
-- participan en la planilla que se esta generando
CREATE TABLE #epp_empleo_participa_planilla (
	epp_codemp int
)

INSERT INTO #epp_empleo_participa_planilla
SELECT distinct ixe_codemp
FROM acc.ixe_incapacidades
WHERE ixe_codppl = @codppl
and sal.empleado_en_gen_planilla(@sessionId, ixe_codemp) = 1


---- Elimina los periodos de incapacidad ya generados para el periodo de planilla
delete from acc.pie_periodos_incapacidad
 where pie_codppl = @codppl-- Para el periodo de planilla
-- Y verifica que se elimine solo para los empleados que participan en planilla
and pie_codixe in (select ixe_codigo from acc.ixe_incapacidades join #epp_empleo_participa_planilla on epp_codemp = ixe_codemp)

-- Toma los codigos de los tipos de riesgos de incapacidad
-- que no afectan el fondo de incapacidad

---- Montos de descuentos de incapacidad por Riesgo Profesional y Maternidad
-- Para estos dos casos no se paga en planilla el tiempo correspondiente a la licencia
INSERT INTO acc.pie_periodos_incapacidad
           (pie_codixe,pie_inicio,pie_final,
		    pie_dias,pie_horas,pie_codppl,pie_aplicado_planilla,pie_planilla_autorizada,
			pie_salario_diario,pie_salario_hora,
			pie_valor_total,pie_valor_a_pagar,pie_valor_a_descontar,
			pie_ajuste_sobre_sal_maximo,pie_codmon,pie_codfin)
SELECT ixe_codigo,ixe_inicio,ixe_final,
	   ixe_dias_incapacitado, ixe_horas_incapacitado,ixe_codppl, 0 aplicado_planilla, 0 planilla_autorizada,
	   valor_hora * 8 salario_diario, valor_hora salario_hora,
	   (CASE WHEN ixe_horas_incapacitado = 0 AND ixe_dias_incapacitado > 0 THEN ixe_dias_incapacitado * 8 ELSE ixe_horas_incapacitado END) * CONVERT(NUMERIC(12,2), valor_hora) valor_total,
	   0.00 valor_a_pagar,
	   (CASE WHEN ixe_horas_incapacitado = 0 AND ixe_dias_incapacitado > 0 THEN ixe_dias_incapacitado * 8 ELSE ixe_horas_incapacitado END) * CONVERT(NUMERIC(12,2), valor_hora) valor_a_descontar,
	   0.00 ajuste_sobre_sal_maximo, 'PAB' codmon, NULL codfin
FROM acc.ixe_incapacidades
JOIN exp.fn_get_datos_rubro_salarial(null, 'S', @fecha_ppl, @codpai)
ON codemp = ixe_codemp
join acc.rin_riesgos_incapacidades on rin_codigo = ixe_codrin
join #epp_empleo_participa_planilla on epp_codemp = ixe_codemp 
WHERE ixe_codppl = @codppl
and rin_utiliza_fondo = 0 -- Toma los tipos de riesgos de incapacidad que no afectan el fondo de incapacidad
and rin_Codpai = @codpai


-- Procesa las otras incapacidades verificando la disponibilidad
-- del fondo de incapacidades

-- Cursor de empleados
DECLARE CUR_EMP CURSOR
FOR
SELECT ixe_codemp,
       ixe_codigo,
       ixe_inicio,
       ixe_final,
       ixe_dias_incapacitado,
       (CASE WHEN ixe_horas_incapacitado = 0 AND IXE_DIAS_INCAPACITADO > 0 THEN IXE_DIAS_INCAPACITADO * 8.00 ELSE ixe_horas_incapacitado END) ixe_horas_incapacitado,
       CONVERT(NUMERIC(12,2), valor_hora) salario_hora,
	   isnull(fin_saldo, 0) * 8.00  HORAS_FONDO_INCAP ,
	   fin_codigo codfin
FROM acc.ixe_incapacidades
JOIN exp.fn_get_datos_rubro_salarial(null, 'S', @fecha_ppl, @codpai)
ON codemp = ixe_codemp
join exp.emp_empleos on emp_codigo = ixe_codemp and emp_estado = 'A'
join acc.rin_riesgos_incapacidades on rin_codigo = ixe_codrin
left join acc.fin_fondos_incapacidad on fin_codemp = ixe_codemp 
and fin_codrin = isnull(gen.get_valor_parametro_int('PA_CodigoRiesgoFondo',null,null,@codcia,null), 5)
WHERE ixe_codppl = @codppl
  and rin_utiliza_fondo = 1
  and rin_Codpai = @codpai
ORDER BY ixe_codemp, ixe_inicio

---Utilizan Fondo
OPEN CUR_EMP
FETCH CUR_EMP INTO @codemp, @ixe_numero, @ixe_inicio, @ixe_final, @ixe_dias, @ixe_horas, @salario_hora, @horas_derecho_incap, @codfin
SET @fetch_emp = @@FETCH_STATUS

WHILE @fetch_emp = 0
BEGIN
	--SET @horas_incapacidad = COALESCE(@horas_incapacidad, 0)
	--SET @horas_derecho_incap = (case when (@horas_derecho_incap - @horas_incapacidad) <= 0 then 0 else (@horas_derecho_incap - @horas_incapacidad) end)
	
	IF @horas_derecho_incap > 0
	BEGIN
		IF @ixe_horas <= @horas_derecho_incap
		BEGIN
			SET @horas_incap_pagar = @ixe_horas
			SET @horas_incap_descontar = @ixe_horas - @horas_incap_pagar
		END
		ELSE
		BEGIN
			SET @horas_incap_pagar = @horas_derecho_incap
			SET @horas_incap_descontar = @ixe_horas - @horas_incap_pagar
		END
	END
	ELSE
	BEGIN
		SET @horas_incap_pagar = 0
		SET @horas_incap_descontar = @ixe_horas
	END
	IF @horas_incap_pagar > 0 
	BEGIN
	    set @ixe_dias = @horas_incap_pagar/ 8.00

		INSERT INTO acc.pie_periodos_incapacidad
				   (pie_codixe,pie_inicio,pie_final
				   ,pie_dias,pie_horas,pie_codppl,pie_aplicado_planilla,pie_planilla_autorizada
				   ,pie_salario_diario
				   ,pie_salario_hora
				   ,pie_valor_total
				   ,pie_valor_a_pagar
				   ,pie_valor_a_descontar
				   ,pie_ajuste_sobre_sal_maximo,pie_codmon,pie_codfin)
		SELECT @ixe_numero, @ixe_inicio, DATEADD(d, @ixe_dias,  @ixe_inicio)-1,
			   @ixe_dias, @horas_incap_pagar, @codppl, 0 aplicado_planilla, 0 planilla_autorizada,
			   @salario_hora * 8,
			   @salario_hora,
			   @horas_incap_pagar * @salario_hora valor_total,
			   @horas_incap_pagar * @salario_hora valor_a_pagar,
			   0 valor_a_descontar,
			   0.00 ajuste_sobre_sal_maximo,'PAB' codmon, @codfin codfin
	END

	IF @horas_incap_descontar > 0
	BEGIN
		SET @ixe_dias = @horas_incap_descontar/ 8.00

		INSERT INTO acc.pie_periodos_incapacidad
				   (pie_codixe,pie_inicio,pie_final
				   ,pie_dias,pie_horas,pie_codppl,pie_aplicado_planilla,pie_planilla_autorizada
				   ,pie_salario_diario
				   ,pie_salario_hora
				   ,pie_valor_total
				   ,pie_valor_a_pagar
				   ,pie_valor_a_descontar
				   ,pie_ajuste_sobre_sal_maximo,pie_codmon,pie_codfin)
		SELECT @ixe_numero, DATEADD(d, -@ixe_dias,  @ixe_FINAL)+1, @ixe_final,
			   @ixe_dias, @horas_incap_descontar, @codppl, 0 aplicado_planilla, 0 planilla_autorizada,
			   @salario_hora * 8,
			   @salario_hora,
			   @horas_incap_descontar * @salario_hora valor_total,
			   0 valor_a_pagar,
			   @horas_incap_descontar * @salario_hora valor_a_descontar,
			   0.00 ajuste_sobre_sal_maximo,'PAB' codmon, NULL codfin
	END

	FETCH CUR_EMP INTO @codemp, @ixe_numero, @ixe_inicio, @ixe_final, @ixe_dias, @ixe_horas, @salario_hora, @horas_derecho_incap, @codfin

	SET @fetch_emp = @@FETCH_STATUS
END
CLOSE CUR_EMP
DEALLOCATE CUR_EMP

DROP TABLE #epp_empleo_participa_planilla

RETURN

GO


