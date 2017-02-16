
GO
/****** Object:  StoredProcedure [pa].[rpe_anexo03]    Script Date: 07/02/2017 10:39:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [pa].[rpe_anexo03]
   @codcia  int,
   @anio    int,
   @mes     int = null,
   @coduni	int = null,
   @verAcumulado varchar(1) = null
as
begin

set nocount on
set dateformat dmy

-- exec rpe_anexo03 1,2012,2,NULL, 'N'

set @verAcumulado = coalesce(@verAcumulado, 'S')

SELECT *
FROM pa.fn_anexo03(@codcia, @anio, @mes, @coduni, @verAcumulado, 'R')

end
