IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_ach_banco_general_acreedores')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_ach_banco_general_acreedores]
GO
/****** Object:  StoredProcedure [pa].[rpe_ach_banco_general_acreedores]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_ach_banco_general_acreedores]
	@codcia int,
	@anio int,
	@mes int,
	@codtcc int = null,
	@codbca int = null,
	@frecuencia_pago varchar(10) = null,
	@frecuencia_planilla int = null,
	@codexp_alternativo varchar(36) = null,
	@codbca_excluir int = null,
	@codtcc_excluir int = null
AS
BEGIN
--set @codcia = 1
--set @codtpl = '1'
--set @codpla = '201501'

-- exec pa.rpe_ach_banco_general_acreedores 1, 2016, 4

set nocount on

declare @codppl int, @concepto varchar(80)

select @concepto = convert(varchar(80), 'Pago Acreedor')

declare @codtdo_cedula int, @codtdo_pasaporte int, @codfpa_ach int

set @codfpa_ach = COALESCE(gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', 'pa', null, null, null), -1)

select cip + char(9) +
	   nombre + char(9) +
	   convert(varchar, ruta) + char(9) +
	   numero_cuenta + char(9) +
	   convert(varchar, tipo_cuenta) + char(9) +
	   convert(varchar, monto) + char(9) +
	   tipo_pago + char(9) +
	   referencia
from (
	--select exp_codigo codexp,
	--	   coalesce(ide_cip, coalesce(ide_pasaporte, '')) cip,
	--	   replace(replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(exp_primer_nom)), '') + ' ' + coalesce(ltrim(rtrim(exp_primer_ape)), '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
	--	   nombre,
	--	   coalesce(bca_ruta, '') ruta,
	--	   coalesce(cbe_numero_cuenta, '') cbe_numero_cuenta,
	--	   coalesce(cbe_tipo_cuenta, '') cbe_tipo_cuenta,
	--	   coalesce(net_neto, 0) monto,
	--	   'C' tipo_pago,
	--	   'REF*TXT**' + @concepto + ' \' referencia
		   
	select dcc_codexp_alternativo codexp,
		   (case cip when '' then pasaporte else cip end) cip,
		   --replace(replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(exp_primer_nom)), '') + ' ' + coalesce(ltrim(rtrim(exp_primer_ape)), '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
		   --replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(dcc_nombre_bca)), '') 
		   replace(replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(dcc_nombre_bca)), '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
		   nombre,
		   dcc_ruta_ach ruta,
		   dcc_referencia numero_cuenta,
		   dcc_tipo_cuenta_bancaria_ach tipo_cuenta,
		   dcc_valor_cobrado monto,
		   'C' tipo_pago,
		   'REF*TXT**' + 'Pago ' + 
				replace(replace(replace(replace(replace(replace(replace(upper(isnull(tcc_descripcion, '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
			+ ' \' referencia

	from pa.rep_dcc_descuentos_ciclicos
	join eor.cia_companias
	on cia_codigo = dcc_codcia
	join exp.exp_expedientes
	on exp_codigo_alternativo = dcc_codexp_alternativo
	left join pa.vw_identificacion_expediente
	on codexp = exp_codigo
	join sal.tcc_tipos_descuento_ciclico
	on tcc_codigo = dcc_codtcc
	where cia_codigo = @codcia
	and dcc_anio = @anio
	and dcc_mes = @mes
	and dcc_codtcc = isnull(@codtcc, dcc_codtcc)
	and dcc_codbca = isnull(@codbca, dcc_codbca)
	and dcc_codfpa = @codfpa_ach
	and dcc_frecuencia_pago = isnull(@frecuencia_pago, dcc_frecuencia_pago)
	and dcc_frecuencia_planilla = isnull(@frecuencia_planilla, dcc_frecuencia_planilla)
	and dcc_codexp_alternativo = isnull(@codexp_alternativo, dcc_codexp_alternativo)
	and dcc_codbca <> (case when @codbca_excluir is null then 0 else @codbca_excluir end)
	and dcc_codtcc <> (case when @codtcc_excluir is null then 0 else @codtcc_excluir end)

) V

END

GO
