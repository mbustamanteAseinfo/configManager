
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.fn_total_horas_laborales_periodo')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
/****** Object:  UserDefinedFunction [sal].[fn_total_horas_laborales_periodo]    Script Date: 1/23/2017 5:35:23 PM ******/
DROP FUNCTION [sal].[fn_total_horas_laborales_periodo]
GO

CREATE FUNCTION [sal].[fn_total_horas_laborales_periodo]
       (@codcia INT, 
     @codemp INT,
     @fIni DATETIME,
     @fFin DATETIME)
RETURNS MONEY
AS
BEGIN

--declare @codcia int, @codemp int, @fIni datetime, @fFin datetime
--set @codcia = 2
--set @codemp = 2
--set @fIni = '2013-05-01'
--set @fFin = '2013-05-15'

DECLARE @horas_sal REAL

SELECT @horas_sal = COALESCE(SUM(COALESCE(djo_total_horas, 0)), 0)
FROM (
   SELECT DISTINCT codcia, codemp, codjor, ffin + colorder - 1 fecha, DATEPART(DW, @fIni + colorder - 1) dia
   FROM (
      SELECT plz_codcia codcia, emp_codigo codemp, emp_codjor codjor, @fIni ffin
      FROM exp.emp_empleos
      JOIN eor.plz_plazas
      ON plz_codigo = emp_codplz
      WHERE plz_codcia = @codcia
      AND emp_codigo = @codemp
   ) V1
   JOIN syscolumns
   ON id = OBJECT_ID('exp.exp_expedientes')
   WHERE (ffin + colorder - 1) <= @fFin
   AND acc.fn_esVacacion(codemp, (ffin + colorder - 1)) = 0
) V2
JOIN sal.jor_jornadas
ON jor_codcia = codcia
AND jor_codigo = codjor
JOIN sal.djo_dias_jornada
ON djo_codjor = jor_codigo
AND djo_dia + 1 = dia
GROUP BY codemp

RETURN COALESCE(@horas_sal, 0)

END

GO
