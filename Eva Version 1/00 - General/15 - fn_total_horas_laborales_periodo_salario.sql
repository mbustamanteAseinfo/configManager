/****** Object:  UserDefinedFunction [sal].[fn_total_horas_laborales_periodo_salario]    Script Date: 12/7/2016 11:54:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [sal].[fn_total_horas_laborales_periodo_salario]
	(@codcia INT, 
     @codemp INT,
     @fIni DATETIME,
     @fFin DATETIME)
RETURNS MONEY
AS
BEGIN

declare @horas_sal money, @rubro_salarial varchar(10), @codpai varchar(2)

set @rubro_salarial = 'S' --'Salarial'
set @codpai = 'pa'

SELECT @horas_sal = CASE WHEN fecha_ultimo_incremento <= @fFin
                         THEN CONVERT(NUMERIC(12,2), salario_hora)
                         ELSE CONVERT(NUMERIC(12,2), salario_hora_anterior)
                    END *
                    ISNULL((SELECT SUM(djo_total_horas) horas_jornada
                              FROM sal.djo_dias_jornada,
                                   (SELECT DATEPART(dw, (@fIni + colorder - 1)) dia
                                      FROM syscolumns
                                     WHERE id = OBJECT_ID('exp.exp_expedientes')
                                       AND (@fIni + colorder - 1) <= @fFin
                                       AND acc.fn_esVacacion(@codemp, (@fIni + colorder - 1)) = 0
                                       ) V3
                             WHERE djo_dia = dia
                               AND djo_codjor = codjor), 0) 
FROM (
     SELECT codjor,
            CAST (
                  CASE WHEN ISNULL(salario_hora, 0) > 0 THEN CONVERT(NUMERIC(12,2), salario_hora)
                       ELSE CASE WHEN ISNULL(num_horas_x_mes, 0) = 0 THEN 0
                                 ELSE ISNULL(salario, 0) / num_horas_x_mes
                            END
                  END AS MONEY) salario_hora,
            ISNULL(fecha_ultimo_incremento, DATEADD(YEAR,-100,GETDATE())) fecha_ultimo_incremento,
            CAST (
                  CASE WHEN fecha_ultimo_incremento IS NULL THEN 0
                       ELSE CASE WHEN ultimo_salario IS NULL THEN 0
                                 ELSE CASE WHEN ISNULL(num_horas_x_mes, 0) = 0 THEN 0
                                           ELSE ISNULL(ultimo_salario, 0) / num_horas_x_mes
                                      END
                            END 
                  END AS MONEY) salario_hora_anterior
     FROM (
			SELECT emp_codjor codjor,
				   emp_codigo codemp,
				   valor_hora salario_hora,
				   num_horas_x_mes,
				   valor salario,
				   fecha_inicio fecha_ultimo_incremento,
				   valor_anterior ultimo_salario
			FROM exp.emp_empleos
			JOIN exp.fn_get_datos_rubro_salarial(@codemp, @rubro_salarial, @fFin, @codpai)
			ON codemp = emp_codigo
     ) V1
) V2

RETURN ISNULL(@horas_sal, 0)
END

GO


