/****** Object:  UserDefinedFunction [acc].[fn_esVacacion]    Script Date: 12/8/2016 12:09:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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


