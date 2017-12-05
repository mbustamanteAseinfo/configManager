IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.fn_contar_caracteres')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [gen].[fn_contar_caracteres]
GO

CREATE FUNCTION [gen].[fn_contar_caracteres](@cadena VARCHAR(MAX), @caracter VARCHAR(255))
RETURNS INT
AS
BEGIN
-- select dbo.fn_contar_caracteres(null,'-')
    DECLARE @posicion INT
    DECLARE @cantidad INT
    
    SET @posicion = 0
    SET @cantidad = 0
    
    WHILE 1=1 AND ISNULL(@cadena,'') <> '' BEGIN
        IF CHARINDEX(@caracter,@cadena,@posicion) <= 0
            BREAK
            
        SET @posicion = CHARINDEX(@caracter,@cadena,@posicion) + 1
        SET @cantidad = @cantidad + 1
    END
    
    RETURN @cantidad
END

GO
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
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.lpad')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [gen].[lpad]
GO

CREATE FUNCTION [gen].[lpad]
 (
  @mstr As varchar(8000),	-- campo
  @nofchars As int,		-- largo
  @fillchar As varchar(8000)=' '-- caracter
 )
RETURNS varchar(200)
AS
BEGIN
 RETURN
  CASE
   WHEN LEN(@mstr) >= @nofchars THEN SUBSTRING(@mstr,1,@nofchars)
   ELSE
    SUBSTRING(REPLICATE(@fillchar,@nofchars),
     1,@nofchars-LEN(@mstr))+@mstr
  END
END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.fn_get_token')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [gen].[fn_get_token]
GO

CREATE FUNCTION [gen].[fn_get_token](@cadena varchar(max),@separador varchar(255),@num_token int) returns varchar(8000)
as
begin

    /*declare @cadena varchar(max)
    declare @separador varchar(255)
    declare @num_token int
    
    set @cadena = '7-896-5783'
    set @separador = '-'
    set @num_token = 3*/

    declare @posicion_inicial int
    declare @posicion_final int
    declare @posicion int
    declare @i int
    declare @token varchar(8000)
    
    set @posicion = 0
    set @posicion_inicial = 1
    set @i = 1
    set @token = null
    
    set @cadena = @cadena + @separador
    while @i <= @num_token begin
        if charindex(@separador,@cadena,@posicion) <= 0
            break
            
        set @posicion = charindex(@separador,@cadena,@posicion) + 1
        
        if @i > 1 
            set @posicion_inicial = @posicion_final + 2
            
        set @posicion_final = @posicion - 2

        set @i = @i + 1
    end
    
    if isnull(@posicion_inicial,0) > 0 begin
        if isnull(@posicion_final,0) = 0 
            set @posicion_final = len(@cadena)
        
        set @token = substring(@cadena,@posicion_inicial,@posicion_final - @posicion_inicial + 1)
    end

    --print @token
    return ltrim(rtrim(@token))

END
GO
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.rpad')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [gen].[rpad]
GO

CREATE FUNCTION [gen].[rpad]
 (
  @mstr As varchar(8000),        -- campo
  @nofchars As int,              -- largo  
  @fillchar As varchar(8000)=' ' -- caracter
 )
RETURNS varchar(200)
AS
BEGIN
 RETURN
  CASE
   WHEN LEN(@mstr) >= @nofchars THEN SUBSTRING(@mstr,1,@nofchars)
   ELSE
     @mstr+SUBSTRING(REPLICATE(@fillchar,@nofchars),
     1,@nofchars-LEN(@mstr))
  END
END



