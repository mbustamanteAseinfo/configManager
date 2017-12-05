/****** Object:  View [sal].[dcc_descuentos_ciclicos_v]    Script Date: 1/23/2017 4:36:17 PM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.dcc_descuentos_ciclicos_v')
                    AND type IN ( N'V' ) )
DROP VIEW [sal].[dcc_descuentos_ciclicos_v]
GO

/****** Object:  View [sal].[dcc_descuentos_ciclicos_v]    Script Date: 1/23/2017 4:36:17 PM ******/

CREATE VIEW [sal].[dcc_descuentos_ciclicos_v]
AS

SELECT	dcc_codigo,
		dcc_codemp,
		dcc_referencia,
		dcc_codtcc,
		dcc_codbca,
		dcc_fecha,
		dcc_fecha_inicio_descuento,
		dcc_codtdc,
		dcc_monto_indefinido,
		dcc_usa_porcentaje,
		dcc_porcentaje,
		dcc_codagr,
		dcc_monto,
		dcc_numero_cuotas,
		dcc_codmon,
		dcc_frecuencia_cuota,
		dcc_total_cobrado,
		dcc_total_no_cobrado,
		dcc_saldo,
		dcc_codtpl,
		dcc_frecuencia_periodo_pla,
		dcc_mes_no_descuenta,
		dcc_accion_liquidacion,
		dcc_observacion,
		dcc_activo,
		dcc_estado, 
		ISNULL(cdc_ultima_cuota,0) dcc_ultima_cuota_pagada, 
		ISNULL(cdc_ultima_cuota,0) + 1 dcc_proxima_cuota,
       ISNULL(pdc_valor_cuota,dcc_valor_cuota) dcc_valor_cuota,
       CASE 
              WHEN (dcc_frecuencia_cuota = 'Mensual' AND dcc_frecuencia_periodo_pla = 0) THEN          
                    CASE 
                      WHEN tpl_frecuencia = 'Semanal' THEN 4
                      WHEN tpl_frecuencia = 'Catorcenal' THEN 2
                      WHEN tpl_frecuencia = 'Quincenal' THEN 2
                      WHEN tpl_frecuencia = 'Mensual' THEN 1
                    END
             ELSE 1 -- se asume que si no le ponen mensual estan poniendo la misma frecuencia que la de la planilla
       END dcc_Divisor
          , ISNULL(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_monto_impar'), 0) dcc_monto_impar
          , ISNULL(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_saldo_impar'), 0) dcc_saldo_impar
          , ISNULL(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_valor_cuota_primera_quincena'), 0) dcc_valor_cuota_primera_quincena
          , ISNULL(gen.get_pb_field_data_float(dcc_property_bag_data, 'dcc_valor_cuota_segunda_quincena'), 0) dcc_valor_cuota_segunda_quincena
  FROM sal.dcc_descuentos_ciclicos
  JOIN sal.tpl_tipo_planilla ON tpl_codigo = dcc_codtpl
  LEFT OUTER JOIN 
                    (SELECT cdc_coddcc,ISNULL(MAX(cdc_numero_cuota),0) cdc_ultima_cuota
                                  FROM sal.cdc_cuotas_descuento_ciclico
                           WHERE cdc_aplicado_planilla = 1
                           GROUP BY cdc_coddcc
                    )c1 ON cdc_coddcc = dcc_codigo
       LEFT OUTER JOIN sal.pdc_plan_pagos_desc_ciclico                    
             ON pdc_coddcc = dcc_codigo
             AND ISNULL(c1.cdc_ultima_cuota, 0) + 1 >= pdc_cuota_inicial
        AND ISNULL(c1.cdc_ultima_cuota, 0) + 1 <= pdc_cuota_final
GO

