
GO

/****** Object:  View [sal].[net_neto_v]    Script Date: 07/02/2017 9:15:30 AM ******/
DROP VIEW [sal].[net_neto_v]
GO

/****** Object:  View [sal].[net_neto_v]    Script Date: 07/02/2017 9:15:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [sal].[net_neto_v] AS (
/**************************************/
/*Vista Standar de EVOLUTION          */
/*                                    */
/**************************************/
       SELECT tig_codcia net_codcia,
              inn_codppl net_codppl,
              ppl_codtpl net_codtpl,
              exp_codigo net_codexp,
              inn_codemp net_codemp,
              emp_codplz net_codplz,
              ppl_fecha_pago net_fecha_pago,
              'I'        net_tipo,
              inn_codtig net_tipo_id,
              inn_valor  net_valor,
              0          net_valor_patronal,
              0          net_ingreso_afecto,
              exp_nombres_apellidos net_nombre_empleado
         FROM sal.inn_ingresos
         JOIN sal.ppl_periodos_planilla ON inn_codppl = ppl_codigo
         JOIN EXP.emp_empleos ON emp_codigo = inn_codemp
         JOIN EXP.exp_expedientes ON exp_codigo = emp_codexp
         JOIN sal.tig_tipos_ingreso ON tig_codigo = inn_codtig
       UNION ALL
       SELECT tdc_codcia net_codcia,
              dss_codppl net_codppl,
              ppl_codtpl net_codtpl,
              exp_codigo net_codexp,
              dss_codemp net_codemp,
              emp_codplz net_codplz,
              ppl_fecha_pago net_fecha_pago,
              'D'        net_tipo,
              dss_codtdc net_tipo_id,
              dss_valor  net_valor,
              0          net_valor_patronal,
              0          net_ingreso_afecto,
              exp_nombres_apellidos net_nombre_empleado
         FROM sal.dss_descuentos
         JOIN sal.ppl_periodos_planilla ON dss_codppl = ppl_codigo
         JOIN EXP.emp_empleos ON emp_codigo = dss_codemp
         JOIN EXP.exp_expedientes ON exp_codigo = emp_codexp
         JOIN sal.tdc_tipos_descuento ON tdc_codigo = dss_codtdc
)

GO


