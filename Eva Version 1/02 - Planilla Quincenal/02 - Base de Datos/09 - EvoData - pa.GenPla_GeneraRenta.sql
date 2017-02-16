IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_GeneraRenta')
                    AND type IN ( N'P', N'PC' ) )

/****** Object:  StoredProcedure [pa].[GenPla_GeneraRenta]    Script Date: 16-01-2017 9:49:43 AM ******/
DROP PROCEDURE [pa].[GenPla_GeneraRenta]
GO

/****** Object:  StoredProcedure [pa].[GenPla_GeneraRenta]    Script Date: 16-01-2017 9:49:43 AM ******/

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
		@codtpl_vacaciones int,
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

select @agr_base_xiii = gen.get_valor_parametro_int('BaseXIII_Salario_CodigoAgrupador', @codpai, null, null, null)

select @agr_descuentos_isr = agr_codigo from sal.agr_agrupadores where agr_codpai = @codpai and agr_abreviatura='DescuentosRentaPTY'
select @agr_base_isr = agr_codigo from sal.agr_agrupadores where agr_codpai = @codpai and agr_abreviatura='IngresosRentaPTY'

-- SEPROSA 14/07/2014
--DECLARE @INCLUIR_DECIMO VARCHAR(1)
--SELECT @INCLUIR_DECIMO = COALESCE(gen.get_valor_parametro_varchar('ISRIncluyeDecimo', @codpai, null, null, null), 'S')

SET @codrsa = isnull(gen.get_valor_parametro_int ('CodigoRubroSalario',null,null,@codcia,null),0)

SET @codtpl_ordinario = isnull(gen.get_valor_parametro_int ('CodigoPlanillaQuincenal',null,null,@codcia,null),0)
SET @codtpl_decimo    = isnull(gen.get_valor_parametro_int ('CodigoPlanillaDecimo',null,null,@codcia,null),0)
SET @codtpl_vacaciones= isnull(gen.get_valor_parametro_int ('CodigoPlanillaVacacion',null,null,@codcia,null),0)

SET @anio_fin = CONVERT(DATETIME,'31/12/'+CONVERT(VARCHAR, @anio), 103)

SET @quincenas_pendientes = CONVERT(INT, DATEDIFF(DD, (case @codtpl when @codtpl_decimo then @fecha_fin else @fecha_ini end), @anio_fin) / 15)

select @decimos_pendientes = 3 - isnull(count(1), 0)
from sal.ppl_periodos_planilla
where ppl_codtpl = @codtpl_decimo
and ppl_anio = @anio
and ppl_estado = 'Autorizado'

set @decimos_pendientes = isnull(@decimos_pendientes, 0)

set @periodos_restantes_calculo = @quincenas_pendientes + @decimos_pendientes * 2 / 3

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
select codcia,
	   codtpl,
	   codppl,
	   codemp,
	   acumulado,
	   retenido,
	   proyectado,
	   deduccion_legal,
	   periodos_restantes_calculo
from (
select @codcia codcia,
	   @codtpl codtpl,
	   @codppl codppl,
	   codemp,
	   pa.fn_agrupador_valores_periodo_isr2 (@codcia, codemp, @anio, @agr_base_isr) acumulado,
	   pa.fn_agrupador_valores_periodo_isr2 (@codcia, codemp, @anio, @agr_descuentos_isr) retenido,
	   CONVERT(NUMERIC(12, 2), ese_salario_quincenal * (case when @quincenas_pendientes <= 0 then 0 else (@quincenas_pendientes - (case when @codtpl in (@codtpl_ordinario, @codtpl_vacaciones) then isnull(dva_dias / 15, 1) else 0 end)) end))
	   + convert(numeric(12, 2), (ese_salario_mensual * @decimos_pendientes * 1) / 3)
	   as proyectado,
	   (case codclr when 'E' then @isr_deduccion_legal else 0 end) deduccion_legal,
	   @periodos_restantes_calculo periodos_restantes_calculo
from (
	SELECT emp_codigo codemp,
		   isnull(gen.get_pb_field_data(exp_property_bag_data, 'exp_clase_renta'), 'A') codclr,
		   ese_salario_quincenal,
		   ese_salario_mensual
	  FROM exp.emp_empleos
	  join exp.exp_expedientes
	  on exp_codigo = emp_codexp
	  join (select ese_codemp, convert(numeric(12,2), ese_valor / 2.00) ese_salario_quincenal, ese_valor ese_salario_mensual
			from exp.ese_estructura_sal_empleos
			where ese_estado = 'V'
			and ese_codrsa = @codrsa
		) salarios
	  on ese_codemp = emp_codigo
	  WHERE emp_codtpl = @codtpl_ordinario
	   AND emp_estado = 'A'
	   AND emp_fecha_ingreso <= @FECHA_FIN
) V
left join (
	select vac_codemp, isnull(sum(isnull(dva_dias, 0)), 0) dva_dias
	from acc.dva_dias_vacacion
	join acc.vac_vacaciones
	on vac_codigo = dva_codvac
	where dva_codppl = @codppl
	group by vac_codemp
) vacaciones
on vac_codemp = codemp
) v
ORDER BY codemp

END

GO


