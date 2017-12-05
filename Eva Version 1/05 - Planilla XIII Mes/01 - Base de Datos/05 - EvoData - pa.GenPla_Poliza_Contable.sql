IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Poliza_Contable')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_Poliza_Contable]    Script Date: 16-01-2017 2:55:49 PM ******/
DROP PROCEDURE [pa].[GenPla_Poliza_Contable]
GO

/****** Object:  StoredProcedure [pa].[GenPla_Poliza_Contable]    Script Date: 16-01-2017 2:55:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- exec [pa].[GenPla_Poliza_Contable] null, 4
CREATE PROCEDURE [pa].[GenPla_Poliza_Contable]
(	@sessionId UNIQUEIDENTIFIER = NULL,
    @codppl INT,
    @userName VARCHAR(100) = NULL
) 
AS

declare
    @CODCIA INT,
	@MES SMALLINT,
	@ANIO INT,
	@CODTPL INT,
	@CTA_Salarios_por_Pagar varchar(50)

SELECT @ANIO = PPL_ANIO,
	   @MES = PPL_MES,
	   @CODTPL = ppl_codtpl,
	   @CODCIA = tpl_codcia
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE PPL_CODIGO = @CODPPL

delete pa.dco_datos_contables
 where dco_codppl = @codppl
	   
SET @CTA_Salarios_por_Pagar = isnull(gen.get_valor_parametro_varchar ('CuentaContableSalarioPorPagar',null,null,@codcia,null),'PENDIENTE')

-- INGRESOS APLICADOS EN LA PLANILLA

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   inn_codppl as dco_codppl, 
	   cco_cta_contable dco_centro_costo,
	   ISNULL(cti_cuenta, 'PENDIENTE') dco_cuenta,
	   tig_descripcion + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as descripcion,
	   Round(sum(inn_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 1, 1) as linea,
	   'G' as Tipo_Partida
into #Ingresos
from sal.inn_ingresos 
join sal.tig_tipos_ingreso on tig_codigo = inn_codtig
left outer join sal.cti_cuentas_tipo_ingreso on cti_codtig = inn_codtig
join exp.emp_empleos on inn_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where inn_codppl = @codppl
group by inn_codppl, cco_cta_contable, cti_cuenta,  tig_descripcion, cco_descripcion, cpp_porcentaje


-- DESCUENTOS APLICADOS EN LA PLANILLA

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   dss_codppl as dco_codppl, 
	   null dco_centro_costo,
	   ISNULL(ctd_cuenta, 'PENDIENTE') dco_cuenta,
	   tdc_descripcion as descripcion,
	   0.00 AS dco_debitos,
	   Round(sum(dss_valor),2) as dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   	identity(int, 1400, 1) linea,
	   'G' as Tipo_Partida
into #Descuentos
from sal.dss_descuentos
join sal.tdc_tipos_descuento on tdc_codigo = dss_codtdc
left outer join sal.ctd_cuentas_tipo_descuen on ctd_codtdc = dss_codtdc
join exp.emp_empleos on dss_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where dss_codppl = @codppl
group by dss_codppl, ctd_cuenta,  tdc_descripcion

---- CREDITO DE SALARIOS POR PAGAR
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   inn_codppl dco_codppl,
	   null dco_centro_costo,
	   @CTA_Salarios_por_Pagar dco_cuenta, 
	   'Fondo por Pagar' decripcion, 
	   0.00 dco_debito,
	  ROUND(ISNULL(SUM(inn_Valor),0) -
				ISNULL((select isnull(sum(dss_valor), 0) 
				from sal.dss_descuentos 
				where dss_codppl = @CODPPL ),0),2) dco_credito,
	@anio anio,
	@mes mes,
	identity(int, 6000,1) linea,
	'G' as Tipo_Partida
into #Acreditamiento
FROM sal.inn_ingresos
where INN_codppl = @codppl
group by inn_codppl


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Ingresos
where dco_codppl = @codppl


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Descuentos
where dco_codppl = @codppl	


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Acreditamiento
where dco_codppl = @codppl
	
----------------------------------------------------------------
--              Provision Seguro Social Patronal              --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   res_codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   'SS Patronal' + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 10000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_SS_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia AND trs_abreviatura='PROV_SSPatronal'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision SS Patronal' dco_descripcion,
	   0.00 dco_debitos,
	   Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 10500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_SS_D
from #Provision_SS_C
join sal.trs_tipos_reserva on trs_codcia=@codcia and trs_abreviatura='PROV_SSPatronal' AND trs_codcia = @CODCIA
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura

insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
	
select *
from #Provision_SS_D
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_SS_C
where dco_codppl = @codppl
----------------------------------------------------------------
--           Provision Seguro Educativo Patronal              --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   res_codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   'SE Patronal' + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 10000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_SE_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia AND trs_abreviatura='PROV_SEPatronal' 
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision SE Patronal' dco_descripcion,
	   0.00 dco_debitos,
	 Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 10500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_SE_D
from #Provision_SE_C
join sal.trs_tipos_reserva on trs_codcia=@codcia AND trs_abreviatura='PROV_SEPatronal' AND trs_codcia = @CODCIA
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
	
select *
from #Provision_SE_D
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_SE_C
where dco_codppl = @codppl
	
----------------------------------------------------------------
--                       Provision XIII                       --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   trs_abreviatura + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 11000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_A_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia and trs_abreviatura='PROV_XIII'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision '+trs_abreviatura dco_descripcion,
	   0.00 dco_debitos,
	   Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 11500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_A_D
from #Provision_A_C
join sal.trs_tipos_reserva on trs_codcia=@codcia and trs_abreviatura='PROV_XIII'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Provision_A_C
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_A_D
where dco_codppl = @codppl	
----------------------------------------------------------------
--                 Provision Prima de Antiguedad              --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   trs_abreviatura + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 12000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_B_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia and trs_abreviatura='PROV_Prima_Anti'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision '+trs_abreviatura dco_descripcion,
	   0.00 dco_debitos,
	   Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 12500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_B_D
from #Provision_B_C
join sal.trs_tipos_reserva on trs_codcia=@codcia and trs_abreviatura='PROV_Prima_Anti'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
	
select *
from #Provision_B_C
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_B_D
where dco_codppl = @codppl	
----------------------------------------------------------------
--                       Provision Vacaciones                 --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   trs_abreviatura + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 13000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_V_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia and trs_abreviatura='PROV_VAC'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision '+trs_abreviatura dco_descripcion,
	   0.00 dco_debitos,
	   Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 13500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_V_D
from #Provision_V_C
join sal.trs_tipos_reserva on trs_codcia=@codcia and trs_abreviatura='PROV_VAC'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Provision_V_C
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_V_D
where dco_codppl = @codppl	
----------------------------------------------------------------
--                    Provision Indemnizacion                 --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   trs_abreviatura + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 14000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_I_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia and trs_abreviatura='PROV_INDEM'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision '+trs_abreviatura dco_descripcion,
	   0.00 dco_debitos,
	   Round(sum(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 14500, 1) as Dco_linea,
	   'R' dco_tipo_partida
	   into #Provision_I_D
from #Provision_I_C
join sal.trs_tipos_reserva on trs_codcia=@codcia and trs_abreviatura='PROV_INDEM'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
where dco_codppl = @codppl
group by dco_codppl, ctr_cuenta_aux, trs_abreviatura


insert into pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
select *
from #Provision_I_C
where dco_codppl = @codppl	
UNION ALL
select *
from #Provision_I_D
where dco_codppl = @codppl	

----------------------------------------------------------------
--                    Provision Riesgo                        --
----------------------------------------------------------------
select @codcia as dco_codcia,
	   @codtpl as dco_codtpl, 
	   @codppl as dco_codppl, 
	   convert(varchar,cco_cta_contable) dco_centro_costo,
	   ISNULL(ctr_cuenta, 'PENDIENTE') dco_cuenta,
	   trs_abreviatura + ' - ' + isnull(cco_descripcion, 'CCO INDEFINIDO') as dco_descripcion,
	   Round(sum(res_valor) * isnull(cpp_porcentaje, 100) / 100.00,2)  as dco_debitos,
	   0.00 AS dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   identity(int, 14000, 1) as Dco_linea,
	   'R' as Dco_Tipo_Partida
into #Provision_R_C
from sal.res_reservas
join sal.trs_tipos_reserva on trs_codigo = res_codtrs and trs_codcia=@codcia and trs_abreviatura='PROV_Riesgo'
left outer join sal.ctr_cuentas_tipo_reserva on ctr_codtrs = trs_codigo
join exp.emp_empleos on res_codemp = emp_codigo
join eor.plz_plazas on emp_codplz = plz_codigo
left outer join eor.cpp_centros_costo_plaza on plz_codigo = cpp_codplz
left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
where res_codppl = @codppl
group by res_codppl, cco_cta_contable, ctr_cuenta, trs_abreviatura, cco_descripcion, cpp_porcentaje

SELECT @codcia AS dco_codcia,
	   @codtpl AS dco_codtpl, 
	   @codppl AS dco_codppl, 
	   ' ' dco_centro_costo,
	   ISNULL(ctr_cuenta_aux, 'PENDIENTE') dco_cuenta,
	   'Provision '+trs_abreviatura dco_descripcion,
	   0.00 dco_debitos,
	   ROUND(SUM(dco_debitos),2) dco_creditos,
	   @anio dco_anio,
	   @mes dco_mes,
	   IDENTITY(INT, 14500, 1) AS Dco_linea,
	   'R' dco_tipo_partida
	   INTO #Provision_R_D
FROM #Provision_I_C
JOIN sal.trs_tipos_reserva ON trs_codcia=@codcia AND trs_abreviatura='PROV_Riesgo'
LEFT OUTER JOIN sal.ctr_cuentas_tipo_reserva ON ctr_codtrs = trs_codigo
WHERE dco_codppl = @codppl
GROUP BY dco_codppl, ctr_cuenta_aux, trs_abreviatura


INSERT INTO pa.dco_datos_contables(DCO_CODCIA, DCO_CODTPL, DCO_CODPPL,
	DCO_CENTRO_COSTO, DCO_CTA_CONTABLE, DCO_DESCRIPCION, DCO_DEBITOS, 
	DCO_CREDITOS, dco_anio, dco_mes, DCO_LINEA, DCO_TIPO_PARTIDA)
	
SELECT *
FROM #Provision_R_C
WHERE dco_codppl = @codppl	
UNION ALL
SELECT *
FROM #Provision_R_D
WHERE dco_codppl = @codppl	
----------------------------------------------------------------

SELECT *
FROM pa.dco_datos_contables
WHERE dco_codppl = @codppl
ORDER BY CONVERT(INT, [DCO_LINEA])


DROP TABLE #Ingresos
DROP TABLE #Descuentos
DROP TABLE #Acreditamiento
DROP TABLE #Provision_SS_D
DROP TABLE #Provision_SS_C
DROP TABLE #Provision_SE_D
DROP TABLE #Provision_SE_C
DROP TABLE #Provision_A_D
DROP TABLE #Provision_A_C
DROP TABLE #Provision_B_D
DROP TABLE #Provision_B_C
DROP TABLE #Provision_V_D
DROP TABLE #Provision_V_C
DROP TABLE #Provision_I_D
DROP TABLE #Provision_I_C
DROP TABLE #Provision_R_D
DROP TABLE #Provision_R_C

GO


