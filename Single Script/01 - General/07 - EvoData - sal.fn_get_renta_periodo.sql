
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.fn_get_renta_periodo')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
/****** Object:  UserDefinedFunction [sal].[fn_total_horas_laborales_periodo]    Script Date: 1/23/2017 5:35:23 PM ******/
DROP FUNCTION [sal].[fn_get_renta_periodo]
GO

CREATE FUNCTION [sal].[fn_get_renta_periodo]
	(@codcia INT, 
     @salario MONEY)
RETURNS MONEY
AS
BEGIN
--select sal.fn_get_renta_periodo(18,4000.00)

--declare 	@codcia int = 18, 
--			@salario money = 4000

DECLARE @renta_anual MONEY, @renta_periodo MONEY,
		@codpai VARCHAR(2), @salario_anual MONEY,
		@incluir_decimo VARCHAR(1), @num_meses REAL

SELECT @num_meses = gen.get_valor_parametro_varchar('ISRNumeroMeses', 'pa', NULL, NULL, NULL)
SET @salario_anual = @salario * @num_meses

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

--select * from gen.get_valor_rango_parametro('TablaRentaMensual', 'pa', null, null, null, null)

SELECT @renta_anual = ((@salario_anual - excedente) * (porcentaje / 100.00)) +  valor
FROM gen.get_valor_rango_parametro('TablaRentaMensual', @codpai, NULL, NULL, NULL, NULL)
WHERE @salario_anual >= inicio
AND @salario_anual <= fin

SET @renta_periodo = CONVERT(NUMERIC(12,2), (@renta_anual / (@num_meses * 2.00)))

--print @salario_anual
--print @renta_anual
--print @renta_periodo
RETURN COALESCE(@renta_periodo, 0)
END

GO


