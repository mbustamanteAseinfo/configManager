
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'acc.fn_esVacacion')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
/****** Object:  UserDefinedFunction [sal].[fn_total_horas_laborales_periodo]    Script Date: 1/23/2017 5:35:23 PM ******/
DROP FUNCTION [acc].[fn_esVacacion]
GO
CREATE FUNCTION [acc].[fn_esVacacion]
	(@codemp INT, @dia DATETIME)
RETURNS MONEY
AS

BEGIN

DECLARE @esVacacion INT

SELECT @esVacacion = COUNT(1)
FROM acc.dva_dias_vacacion
JOIN acc.vac_vacaciones
ON vac_codigo = dva_codvac
WHERE vac_codemp = @codemp
AND @dia >= dva_desde
AND @dia <= dva_hasta
--AND COALESCE(DVA_ANTICIPADO, 'T') <> 'R'

SET @esVacacion = COALESCE(@esVacacion, 0)

RETURN COALESCE(@esVacacion, 0)

END

GO


