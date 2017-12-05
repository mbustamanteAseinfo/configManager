IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_IngresosEventuales_Revalua')
                    AND type IN ( N'P', N'PC' ) )

/****** Object:  StoredProcedure [pa].[GenPla_IngresosEventuales_Revalua]    Script Date: 16-01-2017 11:06:46 AM ******/
DROP PROCEDURE [pa].[GenPla_IngresosEventuales_Revalua]
GO

/****** Object:  StoredProcedure [pa].[GenPla_IngresosEventuales_Revalua]    Script Date: 16-01-2017 11:06:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_IngresosEventuales_Revalua](
	@sessionId VARCHAR(36) = NULL,
    	@codppl INT,
    	@userName VARCHAR(100) = NULL)
AS

-- declaracion de variables locales 
DECLARE @codpai VARCHAR(2),
        @fecha_ppl DATETIME

-- Obtiene los datos de planilla
SELECT @fecha_ppl = ppl_fecha_fin, @codpai = cia_codpai
FROM sal.ppl_periodos_planilla (NOLOCK)
JOIN sal.tpl_tipo_planilla (NOLOCK)
ON tpl_codigo = ppl_codtpl
JOIN eor.cia_companias (NOLOCK)
ON cia_codigo = tpl_codcia
WHERE ppl_codigo = @codppl

UPDATE sal.oin_otros_ingresos
  SET oin_valor_a_pagar = ROUND(valor_hora * ISNULL(oin_factor, 0.00) * ISNULL(oin_num_horas, 0.00), 2),
      oin_salario_hora = valor_hora
FROM exp.fn_get_datos_rubro_salarial(NULL, 'S', @fecha_ppl, @codpai)
WHERE codemp = oin_codemp
AND oin_codppl = @codppl
AND oin_ignorar_en_planilla = 0
AND oin_estado = 'Autorizado'
AND oin_es_valor_fijo = 0
AND sal.empleado_en_gen_planilla(@sessionId, oin_codemp) = 1

RETURN

GO


