
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_HorasExtras_Revalua')
                    AND type IN ( N'P', N'PC' ) ) 
/****** Object:  StoredProcedure [pa].[GenPla_HorasExtras_Revalua]    Script Date: 16-01-2017 9:31:41 AM ******/
DROP PROCEDURE [pa].[GenPla_HorasExtras_Revalua]
GO

/****** Object:  StoredProcedure [pa].[GenPla_HorasExtras_Revalua]    Script Date: 16-01-2017 9:31:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[GenPla_HorasExtras_Revalua] (
	@sessionId VARCHAR(36) = NULL,
    @codppl INT,
    @userName VARCHAR(100) = NULL
)
AS

-- declaracion de variables locales 
DECLARE @codpai VARCHAR(2),
        @fecha_ppl DATETIME

-- Obtiene la fecha de finalizacion y la frecuencia del periodo de planilla que va a utilizar 
SELECT @fecha_ppl = ppl_fecha_fin,
       @codpai = cia_codpai
  FROM sal.ppl_periodos_planilla (NOLOCK)
  JOIN sal.tpl_tipo_planilla (NOLOCK)
  ON tpl_codigo = ppl_codtpl 
  JOIN eor.cia_companias (NOLOCK)
  ON cia_codigo = tpl_codcia
 WHERE ppl_codigo = @codppl


UPDATE sal.ext_horas_extras
  SET ext_valor_a_pagar = ROUND(valor_hora * ISNULL(the_factor,0.0000) * ISNULL(ext_num_horas + ISNULL(ext_num_mins,0)/60.00, 0.0000), 2),
      ext_salario_hora = valor_hora,
      ext_Factor =ISNULL(the_factor,0)
FROM  sal.ext_horas_extras
JOIN exp.fn_get_datos_rubro_salarial(NULL, 'S', @fecha_ppl, @codpai)
  ON codemp  = ext_codemp
JOIN sal.the_tipos_hora_extra ON the_codigo = ext_codthe
WHERE codemp = ext_codemp
AND ext_codppl = @codppl 
AND ext_estado = 'Autorizado'
AND ext_ignorar_en_planilla = 0
AND sal.empleado_en_gen_planilla(@sessionId, ext_codemp) = 1
AND ext_lote_masivo IS NULL
 
RETURN

GO


