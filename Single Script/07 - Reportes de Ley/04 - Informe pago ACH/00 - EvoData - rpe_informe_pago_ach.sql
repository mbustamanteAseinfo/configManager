IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_informe_pago_ach')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE [pa].[rpe_informe_pago_ach]
GO
CREATE PROCEDURE [pa].[rpe_informe_pago_ach]
   @codcia       int = null,
   @codtpl       int = null,
   @codpla       varchar(20) = null,
   @codbco		 int = null,
   @codcco		 int = null
AS

set nocount on
set dateformat dmy

declare @codtdo_cedula int,
		@codtdo_pasaporte int,
		@codfpa_ach int,
		@codppl int,
		@cia_des varchar(150),
		@fecha_pago datetime

select @codtdo_cedula = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Cedula'
and apa_codpai = 'pa'

select @codtdo_pasaporte = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Pasaporte'
and apa_codpai = 'pa'

set @codfpa_ach = COALESCE(gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', 'pa', null, null, null), -1)

select @codppl = ppl_codigo, @cia_des = cia_descripcion, @fecha_pago = ppl_fecha_pago
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
join eor.cia_companias
on cia_codigo = tpl_codcia
where tpl_codcia = @codcia
and tpl_codigo_visual = @codtpl
and ppl_codigo_planilla = @codpla

select @cia_des CIA_DES,
	   CONVERT(varchar, @fecha_pago, 103) FECHA_PAGO,
		isnull(LTRIM(RTRIM(IDE_CIP)),'SIN CEDULA') CEDULA,
		 exp_apellidos_nombres EMP_APELLIDOS_NOMBRES,
		 0 EMP_CODIGO_ANTERIOR,
		'DDA' TIPO,
		ltrim(rtrim(isnull(replace(replace(cbe_numero_cuenta, ' ', ''), '-', ''),0))) CUENTA,
		net_neto MONTO,
		cco_descripcion CENTRO_COSTO,
		bca_nombre BANCO
from exp.exp_expedientes
join ( -- Recupera los montos netos devengados por el colaborador en la planilla para la cual se genera el ACH
	select net_codemp, net_codexp,
		   convert(numeric(12,2), SUM((case net_tipo when 'D' then net_valor * -1 else net_valor end))) net_neto
	from sal.net_neto_v
	where net_codppl = @codppl
	group by net_codemp, net_codexp	
) netos
on net_codexp = exp_codigo
left join ( -- Recupera los numeros de cedula de los expedientes de los colaboradores
	select ide_codexp, ltrim(rtrim(coalesce(ide_numero, ''))) ide_cip
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_cedula
) cedulas
on cedulas.ide_codexp = exp_codigo
--left join ( -- Recupera los numeros de pasaporte de los expedientes de los colaboradores
--	select ide_codexp, ltrim(rtrim(coalesce(ide_numero, ''))) ide_pasaporte
--	from exp.ide_documentos_identificacion
--	where ide_codtdo = @codtdo_pasaporte
--) pasaportes
--on pasaportes.ide_codexp = exp_codigo
join (-- Este deberia ser un JOIN sin el LEFT para que incluya solo los que tienen pago por Banco General
		   -- Recupera los numeros de cuenta que han sido configuradas como formas de pago por ACH para el Banco General
	select emp_codigo, cbe_codexp,
		   ltrim(rtrim(coalesce(cbe_numero_cuenta, ''))) cbe_numero_cuenta,
		   (case coalesce(cbe_tipo_cuenta, '') when 'A' then '04' when 'C' then '03' else 'XX' end) cbe_tipo_cuenta,
		   cpp_codcco,
		   bca_nombre,
		   cco_descripcion
	from exp.cbe_cuentas_banco_exp
	join exp.fpe_formas_pago_empleo
	on fpe_codcbe = cbe_codigo
	join gen.bca_bancos_y_acreedores
	on bca_codigo = cbe_codbca
	join exp.emp_empleos
	on emp_codigo = fpe_codemp
	join eor.plz_plazas
	on plz_codigo = emp_codplz
	left join eor.cpp_centros_costo_plaza
	on cpp_codplz = plz_codigo
	left join eor.cco_centros_de_costo
	on cco_codigo = cpp_codcco
	where fpe_codfpa = @codfpa_ach
	and cbe_codbca = coalesce(@codbco, cbe_codbca)
	and coalesce(cco_codigo, 0) = coalesce(@codcco, coalesce(cco_codigo, 0))
) cuentas
on net_codemp = emp_codigo
where net_neto > 0
order by cco_descripcion, exp_apellidos_nombres

return
