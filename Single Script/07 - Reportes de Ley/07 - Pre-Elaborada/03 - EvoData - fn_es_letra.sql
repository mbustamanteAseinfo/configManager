IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.fn_esLetra')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [gen].[fn_esLetra]
GO

CREATE FUNCTION [gen].[fn_esLetra](@car as varchar(1))
RETURNS int
AS
BEGIN

declare @esLetra int

set @esLetra = 0

if ASCII(@car) >= 65 and ASCII(@car) <= 90
   set @esLetra = 1

RETURN @esLetra

END
