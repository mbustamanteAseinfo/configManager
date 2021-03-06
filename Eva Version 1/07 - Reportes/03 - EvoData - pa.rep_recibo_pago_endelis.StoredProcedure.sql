IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rep_recibo_pago_endelis')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rep_recibo_pago_endelis]
GO
/****** Object:  StoredProcedure [pa].[rep_recibo_pago_endelis]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rep_recibo_pago_endelis]
	@codcia int,
	@codtpl int,
	@codigo_planilla varchar(10),
	@codexp_alternativo varchar(36) = null
as
begin
set nocount on
set dateformat dmy

-- exec pa.rep_recibo_pago_endelis 1, 1, '20160901', '20023'

declare @codppl int, @codpai varchar(2), @codfpa_ach int, @codtig_gasto_rep int, @codtig_salario int

select @codppl = ppl_codigo, @codpai = cia_codpai
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
join eor.cia_companias
on cia_codigo = tpl_codcia
where ppl_codtpl = @codtpl
and ppl_codigo_planilla = @codigo_planilla
and tpl_codcia = @codcia

select @codfpa_ach = gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', @codpai, null, null, null)

select @codtig_salario = 1
select @codtig_gasto_rep = 2

select 1 rpe_or, cia_descripcion as rpe_nombre_empresa,
	   tpl_codigo as rpe_codtpl,
	   ppl_codigo_planilla as rpe_codpla,
	   ppl_fecha_ini as rpe_fecha_ini,
	   ppl_fecha_fin as rpe_fecha_fin,
		(case when ppl_fecha_ini_ingreso_asi is not null and ppl_fecha_fin_ingreso_asi is not null
		 then 'Asistencia del ' + convert(varchar, ppl_fecha_ini_ingreso_asi, 103) + ' al ' + convert(varchar, ppl_fecha_fin_ingreso_asi, 103)
		 else ''
		 end) periodo_asistencia,
	   uni_descripcion as rpe_unidad,
	   cco_descripcion as rpe_centro_nombre,
	   exp_codigo_alternativo as rpe_codexp, 
	   (case isnumeric(exp_codigo_alternativo) when 0 then 0 else convert(numeric, exp_codigo_alternativo) end) as rpe_codemp, 
	   exp_apellidos_nombres as rpe_nombre_empleado,
	   numero_cuenta,
	   plz_codigo, plz_nombre as rpe_puesto,
	   mon_simbolo as MonedaPlanilla,
	   doc_identidad, tipo_doc_identidad, doc_seguro,

	   i.tig_orden,
	   i.tig_descripcion as rpe_nombre_tipo,
	   i.inn_tiempo as rpe_tiempo,
	   i.inn_factor as rpe_factor_inn,
	   i.inn_valor as rpe_percepcion,

	   dl_orden,
	   dl.dl_concepto as rpe_desc_deduccion,
	   dl.dl_valor as rpe_valor_deduccion,

	   da_orden,
	   da.da_concepto as rpe_desc_comercial,
	   da.da_valor as rpe_valor_comercial

from (
	select exp_codigo_alternativo,
		   emp_codigo, 
		   exp_apellidos_nombres,
		   numero_cuenta,
		   tpl_codigo, 
		   ppl_codigo, 
		   tpl_codcia codcia, 
		   cia_descripcion, 
		   ppl_codigo_planilla, 
		   ppl_fecha_ini, 
		   ppl_fecha_fin,
		   ppl_fecha_ini_ingreso_asi,
		   ppl_fecha_fin_ingreso_asi,
		   uni_descripcion,
		   cco_descripcion,
		   plz_codigo, plz_nombre,
		   mon_simbolo,
		   (case cip when '' then pasaporte else cip end) doc_identidad,
		   (case cip when '' then 'Pasaporte' else 'Cédula' end) tipo_doc_identidad,
		   isss doc_seguro
	from exp.emp_empleos
	join exp.exp_expedientes
	on exp_codigo = emp_codexp
	join eor.plz_plazas
	on plz_codigo = emp_codplz
	join sal.tpl_tipo_planilla
	on tpl_codcia = plz_codcia
	join sal.ppl_periodos_planilla
	on ppl_codtpl = tpl_codigo
	join eor.cia_companias
	on cia_codigo = tpl_codcia
	join eor.uni_unidades
	on uni_codigo = plz_coduni
	left join eor.cpp_centros_costo_plaza
	on cpp_codplz = plz_codigo
	left join eor.cco_centros_de_costo
	on cco_codigo = cpp_codcco
	join gen.mon_monedas
	on mon_codigo = tpl_codmon
	left join pa.vw_identificacion_expediente
	on codexp = exp_codigo
	left join (
		select distinct emp_codexp codexp, cbe_numero_cuenta numero_cuenta
		from exp.emp_empleos
		join exp.fpe_formas_pago_empleo
		on fpe_codemp = emp_codigo
		join exp.fpa_formas_pagos
		on fpa_codigo = fpe_codfpa
		join exp.cbe_cuentas_banco_exp
		on cbe_codigo = fpe_codcbe
		where fpa_codigo = @codfpa_ach
	) cuentas
	on cuentas.codexp = exp_codigo
	where ppl_codtpl = @codtpl
	and ppl_codigo_planilla = @codigo_planilla
	and tpl_codcia = @codcia
	and exp_codigo_alternativo = isnull(@codexp_alternativo, exp_codigo_alternativo)
	and exists (
		select 1
		from sal.inn_ingresos
		where inn_codppl = ppl_codigo
		and inn_codemp = emp_codigo
	)
) e
join (
	select 1 codcia, linea from (
	select 1 linea union
	select 2 linea union
	select 3 linea union
	select 4 linea union
	select 5 linea union
	select 6 linea union
	select 7 linea union
	select 8 linea union
	select 9 linea union
	select 10 linea union
	select 11 linea union
	select 12 linea /*union
	select 13 linea union
	select 14 linea union
	select 15 linea*/
	) v
) n
on n.codcia = e.codcia
left join (
	select inn_codemp, tig_codigo, tig_descripcion, tig_orden, inn_tiempo, inn_valor, inn_factor, ROW_NUMBER() over(PARTITION BY inn_codemp order by tig_descripcion) fila
	from (
		select inn_codemp,
			   tig_codigo,
			   tig_abreviatura as tig_descripcion,
			   tig_orden,
			   inn_tiempo, inn_valor,
			   (case when tig_codigo = @codtig_salario
					 then convert(varchar, convert(numeric(12,4), hpa_salario_hora) )
					 when isnull(the_factor, 0) = 0 or tig_codigo in (@codtig_gasto_rep)
					 then ''
					 else convert(varchar, convert(numeric(12,4), the_factor * convert(numeric(12,4), (case tig_codigo when 2 then 0.00 else hpa_salario_hora end))))
				end) 
			   inn_factor
		from sal.inn_ingresos
		join sal.tig_tipos_ingreso
		on tig_codigo = inn_codtig
		left join sal.the_tipos_hora_extra
		on the_codtig = tig_codigo
		left join sal.hpa_hist_periodos_planilla
		on hpa_codemp = inn_codemp
		where inn_codppl = @codppl
		union
		select dss_codemp,
			   tdc_codigo,
			   tdc_abreviatura,
			   tdc_orden + 1000 orden, 
			   dss_tiempo, convert(money, dss_valor * -1.00),
			   '' factor
		from sal.dss_descuentos
		join sal.tdc_tipos_descuento
		on tdc_codigo = dss_codtdc
		where dss_codppl = @codppl
		and tdc_es_descuento_legal = 0
		and not exists (
			select 1
			from sal.dcc_descuentos_ciclicos
			join pa.vw_cdc_cuotas_descuento_ciclico
			on cdc_coddcc = dcc_codigo
			where dcc_codemp = dss_codemp
			and dcc_codtdc = dss_codtdc
			and cdc_valor_cobrado = dss_valor
			and cdc_codppl = dss_codppl
		)
		and exists (
			select 1
			from sal.dag_descuentos_agrupador
			join sal.agr_agrupadores
			on agr_codigo = dag_codagr
			where agr_abreviatura = 'BaseCalculoSeguroSocial'
			and dag_codtdc = tdc_codigo
		)
	) v
) i
on i.fila = linea
and i.inn_codemp = emp_codigo
left join (
	select dss_codemp dl_codemp, tdc_codigo dl_codtdc, tdc_abreviatura as dl_concepto, tdc_orden as dl_orden, dss_valor dl_valor, ROW_NUMBER() over(PARTITION BY dss_codemp order by tdc_abreviatura) dl_fila
	from sal.dss_descuentos
	join sal.tdc_tipos_descuento
	on tdc_codigo = dss_codtdc
	where dss_codppl = @codppl
	and tdc_es_descuento_legal = 1
) dl
on dl_fila = linea
and dl_codemp = emp_codigo
left join (
	select da_codemp, da_codtdc, da_concepto, da_orden, da_valor,
		   ROW_NUMBER() over(PARTITION BY da_codemp order by da_concepto) da_fila
	from (
		select dss_codemp da_codemp,
			   tdc_codigo da_codtdc,
			   tdc_abreviatura +
				(case when cdc_saldo_anterior > 0 then /*char(10) + */' de $' + replace(convert(varchar, convert(money, cdc_saldo_anterior)), '.00', '') else '' end) +
				(case when (cdc_saldo_anterior - cdc_valor_cobrado) /*cdc_saldo_nuevo*/ > 0 then /*char(10) + */' a $' + replace(convert(varchar, convert(money, (cdc_saldo_anterior - cdc_valor_cobrado) /*cdc_saldo_nuevo*/)), '.00', '') else '' end) da_concepto, 
			   tdc_orden da_orden,
			   --dss_valor da_valor
			   cdc_valor_cobrado da_valor
		from sal.dss_descuentos
		join sal.tdc_tipos_descuento
		on tdc_codigo = dss_codtdc
		join sal.dcc_descuentos_ciclicos
		on dcc_codemp = dss_codemp
		and dcc_codtdc = dss_codtdc
		join (
			
			select cdc_codppl, cdc_coddcc, sum(cdc_valor_cobrado) cdc_valor_cobrado, max(cdc_saldo_anterior) cdc_saldo_anterior
			from pa.vw_cdc_cuotas_descuento_ciclico
			where cdc_codppl = @codppl
			group by cdc_codppl, cdc_coddcc

			--pa.vw_cdc_cuotas_descuento_ciclico
			--on cdc_coddcc = dcc_codigo
			--and cdc_valor_cobrado = dss_valor
			--and cdc_codppl = dss_codppl
		) v
		on cdc_coddcc = dcc_codigo
		where dss_codppl = @codppl
		and tdc_es_descuento_legal = 0
		union
		select dss_codemp,
				tdc_codigo,
				tdc_abreviatura,
				tdc_orden, 
				dss_valor
		from sal.dss_descuentos
		join sal.tdc_tipos_descuento
		on tdc_codigo = dss_codtdc
		where dss_codppl = @codppl
		and tdc_es_descuento_legal = 0
		and not exists (
			select 1
			from sal.dcc_descuentos_ciclicos
			join pa.vw_cdc_cuotas_descuento_ciclico
			on cdc_coddcc = dcc_codigo
			where dcc_codemp = dss_codemp
			and dcc_codtdc = dss_codtdc
			and cdc_valor_cobrado = dss_valor
			and cdc_codppl = dss_codppl
		)
		and not exists (
			select 1
			from sal.dag_descuentos_agrupador
			join sal.agr_agrupadores
			on agr_codigo = dag_codagr
			where agr_abreviatura = 'BaseCalculoSeguroSocial'
			and dag_codtdc = tdc_codigo
		)
	) v
) da
on da_fila = linea
and da_codemp = emp_codigo
--where tig_descripcion is not null or dl_concepto is not null or da_concepto is not null
order by exp_apellidos_nombres, linea, i.fila, i.tig_orden--, dl_orden, da_orden

end

GO
