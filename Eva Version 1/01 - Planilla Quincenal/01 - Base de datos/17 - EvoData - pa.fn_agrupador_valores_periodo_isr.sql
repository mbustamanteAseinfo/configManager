IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.fn_agrupador_valores_periodo_isr')
                    AND type IN ( N'TF', N'FN', N'IF' ) ) 
	
/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
DROP FUNCTION [pa].[fn_agrupador_valores_periodo_isr]
GO

/****** Object:  UserDefinedFunction [pa].[fn_agrupador_valores_periodo_isr]    Script Date: 16-01-2017 11:28:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------------  
-- Evolution - Panama                                                                         --
-- Obtiene el acumulado de Ingresos y Descuentos de un periodo y agrupador dado               --
------------------------------------------------------------------------------------------------
CREATE FUNCTION [pa].[fn_agrupador_valores_periodo_isr]
	(@codcia INT, 
    @codemp INT,
    @anio INT,
    @codtdp INT)
RETURNS MONEY
AS

BEGIN
   declare @valor money
   SELECT @valor = SUM(inn_valor)
     FROM (
            SELECT inn_codemp, 
					   CASE iag_aplicacion
								  WHEN 'Porcentaje' THEN CAST(ROUND(ISNULL(inn_valor, 0) * (ISNULL(iag_valor, 0.0) / 100.0), 2) AS MONEY)
								  WHEN 'ExcedenteDe' THEN CASE WHEN ISNULL(inn_valor, 0) > ISNULL(iag_valor, 0) THEN ISNULL(inn_valor, 0) - ISNULL(iag_valor, 0) ELSE 0 END
								  ELSE CAST(ROUND(ISNULL(iag_valor, 0.0), 2) AS MONEY) END *
					   CASE WHEN iag_signo = 1 THEN
								 1.00
							ELSE  -1.00 END inn_valor,
					   ppl_mes,
					   ppl_anio
				  FROM sal.inn_ingresos
				  JOIN exp.emp_empleos ON emp_codigo = inn_codemp
   				  JOIN sal.ppl_periodos_planilla ON inn_codppl = ppl_codigo
   				  JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
				  JOIN sal.iag_ingresos_agrupador ON inn_codtig = iag_codtig
				  JOIN sal.agr_agrupadores ON agr_codigo = iag_codagr AND agr_para_calculo = 1
				 WHERE tpl_codcia = @codcia
               AND ppl_anio = @anio
               AND iag_codagr = @codtdp
               AND ppl_fecha_pago >= emp_fecha_ingreso
               AND inn_codemp = @codemp
               AND ppl_estado = 'Autorizado'
            UNION ALL
            SELECT dss_codemp, 
					   CASE dag_aplicacion 
								  WHEN 'Porcentaje' THEN CAST(ROUND(ISNULL(dss_valor, 0) * (ISNULL(dag_valor, 0.0) / 100.0), 2) AS MONEY)
								  WHEN 'ExcedenteDe' THEN CASE WHEN ISNULL(dss_valor, 0) > ISNULL(dag_valor, 0) THEN ISNULL(dss_valor, 0) - ISNULL(dag_valor, 0) ELSE 0 END
								  ELSE CAST(ROUND(ISNULL(dag_valor, 0.0), 2) AS MONEY) END *
					   CASE WHEN dag_signo = 1 THEN
								 1.00
							ELSE  -1.00 END inn_valor,
					   ppl_mes,
					   ppl_anio
				  FROM sal.dss_descuentos
				  JOIN exp.emp_empleos ON emp_codigo = dss_codemp
   			   	  JOIN sal.ppl_periodos_planilla ON dss_codppl = ppl_codigo
   				  JOIN sal.tpl_tipo_planilla ON tpl_codigo = ppl_codtpl
				  JOIN sal.dag_descuentos_agrupador ON dss_codtdc = dag_codtdc
				  JOIN sal.agr_agrupadores ON agr_codigo = dag_codagr AND agr_para_calculo = 1
				 WHERE tpl_codcia = @codcia
               AND ppl_anio = @anio
               AND dag_codagr = @codtdp
               AND ppl_fecha_pago >= emp_fecha_ingreso
               AND dss_codemp = @codemp
               AND ppl_estado = 'Autorizado'
          ) v1
   
   RETURN ISNULL(@valor, 0)
END



GO


