IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Calcula_Retroactivos_GastoRep')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_Calcula_Retroactivos_GastoRep]    Script Date: 16-01-2017 11:20:43 AM ******/
DROP PROCEDURE [pa].[GenPla_Calcula_Retroactivos_GastoRep]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Calcula_Retroactivos_GastoRep]    Script Date: 16-01-2017 11:20:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_Calcula_Retroactivos_GastoRep](
	@sessionId UNIQUEIDENTIFIER = NULL,
    	@codppl INT,
    	@userName VARCHAR(100) = NULL
)
AS
BEGIN

declare @pago_salario_previo numeric(12,2), @pago_salario_nuevo numeric(12,2), @salario_hora_actual numeric(12,4), @salario_hora_anterior numeric(12,4)
declare @ppl_fecha_ini datetime, @ppl_fecha_fin datetime, @fetch int, @fecha_vigencia datetime, @retroactivo numeric(12,2), @horas_laborales numeric(12,2)
declare @codemp int, @fIni datetime, @fFin datetime, @codpai varchar(2), @codcia int

-- Toma el rango de fechas de la planilla
SELECT @ppl_fecha_ini = PPL_FECHA_INI, @ppl_fecha_fin = PPL_FECHA_FIN,
	   @codcia = tpl_codcia, @codpai = cia_codpai
FROM sal.ppl_periodos_planilla (nolock)
JOIN sal.tpl_tipo_planilla (nolock)
ON tpl_codigo = ppl_codtpl
JOIN eor.cia_companias (nolock)
on cia_codigo = tpl_codcia
WHERE ppl_codigo = @codppl

-- Elimina los registros generados previamente para el salario en esta planilla
DELETE FROM tmp.PIR_PAGOS_INC_RETROACT
WHERE pir_codppl = @codppl
AND PIR_CODRSA = gen.get_valor_parametro_int('CodigoRubroGastoRep', null, null, @codcia, null)
AND sal.empleado_en_gen_planilla(@sessionId, PIR_CODEMP) = 1

--DECLARE @max_id INT

--- OBTIENE EL CORRELATIVO MAXIMO
--SET @max_id = isnull((SELECT MAX(PIR_CODIGO) FROM tmp.PIR_PAGOS_INC_RETROACT), 0) + 1

-- Toma un listado de los incrementos autorizados en el periodo que cubre la planilla
-- cuya fecha de vigencia es anterior a la fecha inicial de la planilla
DECLARE CUR_INC CURSOR
FOR
SELECT DISTINCT
       inc_codemp,
	   idr_fecha_vigencia,
       convert(numeric(12,4),(valor/num_horas_x_mes)) salario_hora_actual,
	   convert(numeric(12,4),(valor_anterior/num_horas_x_mes)) salario_hora_anterior
FROM acc.inc_incrementos
JOIN acc.idr_incremento_detalle_rubros ON idr_codinc = INC_CODIGO
JOIN acc.tin_tipos_incremento ON tin_codigo = inc_codtin
JOIN exp.fn_get_datos_rubro_salarial(null, 'G', @ppl_fecha_fin, @codpai)
ON codemp = inc_codemp
WHERE tin_codcia = @codcia
AND INC_ESTADO = 'Autorizado'
AND inc_fecha_solicitud >= @ppl_fecha_ini
AND inc_fecha_solicitud <= @ppl_fecha_fin
AND idr_es_retroactivo = 1
AND idr_fecha_vigencia < @ppl_fecha_ini
AND idr_accion in ('Modificar','Agregar')
AND idr_codrsa = gen.get_valor_parametro_int('CodigoRubroGastoRep', @codpai, null, null, null)
AND sal.empleado_en_gen_planilla(@sessionId, inc_codemp) = 1

OPEN CUR_INC
FETCH CUR_INC INTO @codemp, @fecha_vigencia, @salario_hora_actual, @salario_hora_anterior
SET @fetch = @@FETCH_STATUS

-- La fecha hasta la cual se calcula el retroactivo es un dia anterior al inicio de la planilla
set @fFin = dateadd(dd, -1, @ppl_fecha_ini)

WHILE @fetch = 0
BEGIN
	-- La fecha inicial del retroactivo es la fecha de vigencia del incremento
	set @fIni = @fecha_vigencia
	
	-- Calcula el número de horas laborales comprendidas desde la fecha de vigencia del incremento
	select @horas_laborales =  COALESCE((select count(dia) --SUM(djo_total_horas)
                              from sal.djo_dias_jornada, sal.jor_jornadas,
                                   (select datepart(dw, (@fIni + colorder - 1)) dia, (@fIni + colorder - 1) fecha, exp.fn_get_jornada_emp_fecha(@codemp, (@fIni + colorder - 1)) codjor
                                      from syscolumns 
                                     where id = object_id('exp.exp_expedientes')
                                       and (@fIni + colorder - 1) <= @fFin
                                       --and acc.fn_esVacacion(@codemp, (@fIni + colorder - 1)) = 0
                                       ) v1 
                             where jor_codigo = djo_codjor
                               and djo_dia = (case when dia - 1 <= 0 then 7 else dia - 1 end)
                               and jor_codigo = codjor
                               and jor_codcia = @codcia
							   and djo_total_horas > 0), 0)

	-- Calcula el monto del salario regular para el período a partir del cual tiene vigencia el retroactivo
	SELECT @pago_salario_previo =  COALESCE((SELECT SUM(djo_total_horas * @salario_hora_anterior) 
                              FROM sal.djo_dias_jornada, sal.jor_jornadas,
                                   (SELECT DATEPART(dw, (@fIni + colorder - 1)) dia, (@fIni + colorder - 1) fecha, exp.fn_get_jornada_emp_fecha(@codemp, (@fIni + colorder - 1)) codjor
                                      FROM syscolumns 
                                     WHERE id = OBJECT_ID('exp.exp_expedientes')
                                       AND (@fIni + colorder - 1) <= @fFin
                                       --and acc.fn_esVacacion(@codemp, (@fIni + colorder - 1)) = 0
                                       ) v1 
                             WHERE jor_codigo = djo_codjor
                               AND djo_dia = (CASE WHEN dia - 1 <= 0 THEN 7 ELSE dia - 1 END)
                               AND jor_codigo = codjor
                               AND jor_codcia = @codcia), 0)

	-- Calcula el monto del salario con el incremento para el período a partir del cual tiene vigencia el incremento
	SELECT @pago_salario_nuevo =  COALESCE((SELECT SUM(djo_total_horas * @salario_hora_actual)
								  FROM sal.djo_dias_jornada, sal.jor_jornadas,
									   (SELECT DATEPART(dw, (@fIni + colorder - 1)) dia, (@fIni + colorder - 1) fecha, exp.fn_get_jornada_emp_fecha(@codemp, (@fIni + colorder - 1)) codjor
										  FROM syscolumns 
										 WHERE id = OBJECT_ID('exp.exp_expedientes')
										   AND (@fIni + colorder - 1) <= @fFin
										   --and acc.fn_esVacacion(@codemp, (@fIni + colorder - 1)) = 0
										   ) v1 
								 WHERE jor_codigo = djo_codjor
								   AND djo_dia = (CASE WHEN dia - 1 <= 0 THEN 7 ELSE dia - 1 END)
								   AND jor_codigo = codjor
								   AND jor_codcia = @codcia), 0)

	-- El monto a pagar como retroactivo
	-- es el monto en exceso del salario con el incremento
	-- menos el valor del salario regular
	SET @retroactivo = @pago_salario_nuevo - @pago_salario_previo

	-- Registra el monto y horas del incremento para su pago en la planilla
	IF @retroactivo > 0
	BEGIN
		INSERT INTO tmp.PIR_PAGOS_INC_RETROACT(/*PIR_CODIGO,*/ PIR_CODPPL, PIR_CODEMP, PIR_MONTO_RETROACTIVO, PIR_DIAS_RETROACTIVO, PIR_CODRSA)
		VALUES (/*@max_id,*/ @codppl, @codemp, @retroactivo, @horas_laborales, gen.get_valor_parametro_int('CodigoRubroGastoRep', @codpai, NULL, NULL, NULL))

		--SET @max_id = @max_id + 1
	END
	
	--select @pago_salario_previo pago_salario_previo, @pago_salario_nuevo pago_salario_nuevo, @retroactivo retroactivo, @horas_laborales horas
    
    FETCH CUR_INC INTO @codemp, @fecha_vigencia, @salario_hora_actual, @salario_hora_anterior
	SET @fetch = @@FETCH_STATUS
END

CLOSE CUR_INC
DEALLOCATE CUR_INC

END

GO


