
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.fn_dias_domingo')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
/****** Object:  UserDefinedFunction [sal].[fn_total_horas_laborales_periodo]    Script Date: 1/23/2017 5:35:23 PM ******/
DROP FUNCTION [sal].[fn_dias_domingo]
GO

CREATE FUNCTION [sal].[fn_dias_domingo](@FECHA_INICIO DATETIME, @FECHA_FIN DATETIME) 
RETURNS INT AS
BEGIN
DECLARE @DIA_DOMINGO INT

SET @DIA_DOMINGO = 0

WHILE @FECHA_FIN >= @FECHA_INICIO
BEGIN
	IF DATEPART(dw, @FECHA_INICIO) = 1
	BEGIN
		SET @DIA_DOMINGO = @DIA_DOMINGO + 1
	END
	SET @FECHA_INICIO = @FECHA_INICIO + 1 
END
			
RETURN @DIA_DOMINGO		

END

GO


