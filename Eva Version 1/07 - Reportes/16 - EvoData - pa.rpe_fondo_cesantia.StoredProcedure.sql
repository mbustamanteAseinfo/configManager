IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_fondo_cesantia')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_fondo_cesantia]
GO
/****** Object:  StoredProcedure [pa].[rpe_fondo_cesantia]    Script Date: 11/22/2016 2:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_fondo_cesantia]
    @codcia int,
    @anio int,
    @mes_ini int,
    @mes_fin int
AS

SET NOCOUNT ON

declare @trimestre smallint

set @trimestre = @mes_fin / 3

SELECT FND_CODCIA,
	   cia_descripcion FND_CIADES,
	   fnd_codigo_alternativo FND_CODEMP,
	   FND_TRIMESTRE,
	   FND_ANIO,
	   exp_apellidos_nombres FND_NOMBRE,
	   FND_SEXO,
	   FND_CIP,
	   FND_ISSS,
	   FND_EDAD,
	   FND_FECHA_NAC,
	   FND_FECHA_INGRESO,
	   FND_FECHA_RETIRO,
	   FND_SALARIO_HORA,
	   FND_SALARIO_MENSUAL,
	   FND_SALARIO_TRIMESTRE,
	   FND_SALARIO_MES1,
	   FND_SALARIO_MES2,
	   FND_SALARIO_MES3,
	   FND_PA_TRIMESTRE,
	   FND_INDM_TRIMESTRE,
	   FND_TOT_APORTADO
FROM pa.fnd_fondo_cesantia
join eor.cia_companias
on cia_codigo = fnd_codcia
join exp.exp_expedientes
on exp_codigo_alternativo = fnd_codigo_alternativo
where fnd_codcia = @codcia
and fnd_anio = @anio
and fnd_trimestre = @trimestre
   
RETURN

GO
