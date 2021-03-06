IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_ach_banco_general_1ctvo')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_ach_banco_general_1ctvo]
GO
/****** Object:  StoredProcedure [pa].[rpe_ach_banco_general_1ctvo]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_ach_banco_general_1ctvo]
	@codcia int
AS
BEGIN
--set @codcia = 1
--set @codtpl = '1'
--set @codpla = '201501'

set nocount on

declare @concepto varchar(80)

set @concepto = 'Validacion de generacion de ACH'

declare @codtdo_cedula int, @codtdo_pasaporte int, @codfpa_ach int

select @codtdo_cedula = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Cedula'
and apa_codpai = 'pa'

select @codtdo_pasaporte = apa_valor
from gen.apa_alcances_parametros
where apa_codpar = 'CodigoDoc_Pasaporte'
and apa_codpai = 'pa'

set @codfpa_ach = COALESCE(gen.get_valor_parametro_int('CodigoFormaPagoTransferencia', 'pa', null, null, null), -1)

--select gen.rpad(cip, 15, SPACE(1)) +
--	   gen.rpad(nombre, 22, SPACE(1)) +
--	   gen.lpad(ruta, 9, space(1)) +
--	   gen.lpad(cbe_numero_cuenta, 17, SPACE(1)) +
--	   gen.lpad(cbe_tipo_cuenta, 2, space(1)) +
--	   gen.lpad(monto, 11, SPACE(1)) +
--	   tipo_pago +
--	   gen.rpad(referencia, 80, SPACE(1))
select cip + char(9) +
	   nombre + char(9) +
	   convert(varchar, ruta) + char(9) +
	   cbe_numero_cuenta + char(9) +
	   convert(varchar, cbe_tipo_cuenta) + char(9) +
	   convert(varchar, monto) + char(9) +
	   tipo_pago + char(9) +
	   referencia
from (
	select exp_codigo codexp,
		   ltrim(rtrim(coalesce(ide_cip, coalesce(ide_pasaporte, '')))) cip,
		   replace(replace(replace(replace(replace(replace(replace(upper(coalesce(ltrim(rtrim(exp_primer_nom)), '') + ' ' + coalesce(ltrim(rtrim(exp_primer_ape)), '')), 'Á', 'A'), 'É', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ú', 'U'), 'Ñ', 'N'), '-', ' ')
		   nombre,
		   coalesce(bca_ruta, '') ruta,
		   ltrim(rtrim(coalesce(cbe_numero_cuenta, ''))) cbe_numero_cuenta,
		   coalesce(cbe_tipo_cuenta, '') cbe_tipo_cuenta,
		   coalesce(0.01, 0) monto,
		   'C' tipo_pago,
		   'REF*TXT**' + @concepto + ' \' referencia
		   
	from exp.exp_expedientes
	left join ( -- Recupera los numeros de cedula de los expedientes de los colaboradores
		select ide_codexp, ide_numero ide_cip
		from exp.ide_documentos_identificacion
		where ide_codtdo = @codtdo_cedula
	) cedulas
	on cedulas.ide_codexp = exp_codigo
	left join ( -- Recupera los numeros de pasaporte de los expedientes de los colaboradores
		select ide_codexp, ide_numero ide_pasaporte
		from exp.ide_documentos_identificacion
		where ide_codtdo = @codtdo_pasaporte
	) pasaportes
	on pasaportes.ide_codexp = exp_codigo
	join (-- Este deberia ser un JOIN sin el LEFT para que incluya solo los que tienen pago por Banco General
			   -- Recupera los numeros de cuenta que han sido configuradas como formas de pago por ACH para el Banco General
		select cbe_codexp,
			   cbe_codbca,
			   cbe_numero_cuenta,
			   (case cbe_tipo_cuenta when 'A' then '04' when 'C' then '03' else 'XX' end) cbe_tipo_cuenta
		from exp.cbe_cuentas_banco_exp
		join exp.fpe_formas_pago_empleo
		on fpe_codcbe = cbe_codigo
		where fpe_codfpa = @codfpa_ach
		--and cbe_codbca = @codbco_ach
	) cuentas
	on cbe_codexp = exp_codigo
	join (
		select bca_codigo, gen.get_pb_field_data(bca_property_bag_data, 'bca_ruta') bca_ruta
		from gen.bca_bancos_y_acreedores
	) bancos
	on bca_codigo = cbe_codbca
) V

END

GO
