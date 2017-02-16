
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'exp.fn_get_datos_rubro_salarial')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
/****** Object:  UserDefinedFunction [exp].[fn_get_datos_rubro_salarial]    Script Date: 16-01-2017 9:33:53 AM ******/
DROP FUNCTION [exp].[fn_get_datos_rubro_salarial]
GO

/****** Object:  UserDefinedFunction [exp].[fn_get_datos_rubro_salarial]    Script Date: 16-01-2017 9:33:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [exp].[fn_get_datos_rubro_salarial]
	(@codemp INT, @rubro_salarial VARCHAR(1), @fecha_vigencia DATETIME, @codpai VARCHAR(2))
RETURNS @datosSalario TABLE (
	codcia INT,
	codemp INT,
	valor MONEY,
	valor_hora MONEY,
	num_horas_x_mes NUMERIC(10,4),
	exp_valor VARCHAR(15),
	valor_anterior MONEY,
	fecha_inicio DATETIME,
	fecha_fin DATETIME,
	codtpl INT,
	estado VARCHAR(1),
	estado_activo VARCHAR(1),
    horassemanales NUMERIC(10,4),
    rataxhora NUMERIC(10,4),
    codmon VARCHAR(3),
    codplz INT
)
AS
BEGIN

-- Retorna los datos del rubro salarial indicado
-- donde
--   S: Salario
--   G: Gasto de Representación
-- SELECT * FROM exp.fn_get_datos_rubro_salarial(null, 'S', '2013-05-08', 'pa')

declare @parametro_salarial varchar(100),@semanasxmes numeric (10,4)

if @rubro_salarial = 'S' set @parametro_salarial = 'CodigoRubroSalario'
if @rubro_salarial = 'G' set @parametro_salarial = 'CodigoRubroGastoRep'

select @semanasxmes = isnull(gen.get_valor_parametro_float('FactorSemanasxMes', @codpai, null, null, null),4.3333)
if @semanasxmes  = 0
    set @semanasxmes   = 4.3333

INSERT INTO @datosSalario (codcia, codemp, valor, valor_hora, num_horas_x_mes, exp_valor, valor_anterior, fecha_inicio, fecha_fin, codtpl, estado, estado_activo, horassemanales,rataxhora, codmon, codplz)
SELECT cia_codigo codcia,
       ese_codemp codemp,
       ese_valor valor,
       ese_valor_hora valor_hora,
       ese_num_horas_x_mes num_horas_x_mes,
       ese_exp_valor exp_valor,
       ese_valor_anterior valor_anterior,
       ese_fecha_inicio fecha_inicio,
       ese_fecha_fin fecha_fin,
       emp_codtpl codtpl,
       emp_estado estado,
       emp_estado_activo estado_activo,
       ISNULL(jor_total_horas,44.00),
       CASE WHEN ISNULL(jor_total_horas,0) > 0 
            THEN (ese_Valor /@semanasxmes) / jor_total_horas
            ELSE (ese_Valor /@semanasxmes) / 44.00
        END,
       ese_codmon,
       emp_codplz
FROM exp.ese_estructura_sal_empleos
JOIN exp.rsa_rubros_salariales
ON rsa_codigo = ese_codrsa
JOIN -- Toma un listado de los mas recientes codigos dentro para la fecha indicada
	 (SELECT ese_int.ese_codemp codemp, ese_int.ese_codigo max_codese
	  FROM exp.ese_estructura_sal_empleos ese_int
	  WHERE ese_int.ese_fecha_inicio <= @fecha_vigencia
	  AND COALESCE(ese_int.ese_fecha_fin, @fecha_vigencia) >= @fecha_vigencia
	  --GROUP BY ese_int.ese_codemp
	  ) ese
ON ese.codemp = ese_codemp
AND ese.max_codese = ese_codigo
JOIN eor.cia_companias
ON cia_codigo = rsa_codcia
JOIN exp.emp_empleos
ON emp_codigo = ese_codemp
JOIN eor.plz_plazas
ON plz_codigo = emp_codplz
AND plz_codcia = cia_codigo
LEFT JOIN sal.jor_jornadas ON jor_codigo = emp_Codjor
WHERE ese_codemp = COALESCE(@codemp, ese_codemp)
--AND ese_estado = 'V'
AND rsa_codigo = gen.get_valor_parametro_varchar(@parametro_salarial, NULL, NULL, cia_codigo, NULL)
AND ese_fecha_inicio <= @fecha_vigencia
AND COALESCE(ese_fecha_fin, @fecha_vigencia) >= @fecha_vigencia

RETURN


END

GO


