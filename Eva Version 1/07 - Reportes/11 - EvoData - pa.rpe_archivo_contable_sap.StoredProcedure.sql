IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_archivo_contable_sap')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_archivo_contable_sap]
GO
/****** Object:  StoredProcedure [pa].[rpe_archivo_contable_sap]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [pa].[rpe_archivo_contable_sap]
	@codtpl int,
	@codigo_planilla varchar(10),
	@fecha_asiento varchar(10) = null,
	@coduni int = null,
	@coduni_excluir int = null,
	@tipo_partida varchar(1) = null
as
begin

declare @codppl int, @fecha_archivo datetime, @fecha_texto varchar(25), @fecha_archivo_texto varchar(8),
		@tipo_documento varchar(2), @sociedad varchar(4),
		@referencia_planilla varchar(16)

set nocount on
set dateformat dmy

set @tipo_documento = 'NO'
set @sociedad = '4500'

select @codppl = ppl_codigo,
	   @fecha_archivo = (case when coalesce(@fecha_asiento, '') = '' then ppl_fecha_pago else convert(datetime, @fecha_asiento) end),
	   @referencia_planilla = gen.get_pb_field_data(tpl_property_bag_data, 'tpl_nombre_contable')
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
where ppl_codtpl = @codtpl
and ppl_codigo_planilla = @codigo_planilla

select @fecha_texto = right('00' + convert(varchar, day(@fecha_archivo)), 2) + ' DE ' + upper(gen.fn_get_NombreMes(month(@fecha_archivo))) + ' ' + convert(varchar, year(@fecha_archivo))
select @fecha_archivo_texto = right('00' + convert(varchar, day(@fecha_archivo)), 2) + right('00' + convert(varchar, month(@fecha_archivo)), 2) + convert(varchar, year(@fecha_archivo))

-- select @codppl codppl, @fecha_archivo fecha_archivo, @fecha_texto fecha_texto, @referencia_planilla referencia_planilla, @fecha_archivo_texto fecha_archivo_texto

;
with datos
as (
		select 
			   dco_cta_contable concepto_cuenta,
			   dco_descripcion concepto,
			   isnull(dco_centro_costo, '') centro_costo_cuenta,
			   gen.fn_crufl_sin_tildes_case(coalesce(hpa_nombre_unidad, '')) unidad_administrativa,
			   (case when isnull(dco_debitos, 0) > 0 then '40' else '50' end) codigo_tipo_aplicacion,
			   isnull(dco_debitos, 0) + isnull(dco_creditos, 0) monto
		   
		from pa.dco_datos_contables
		join sal.hpa_hist_periodos_planilla
		on hpa_codppl= dco_codppl
		and hpa_codemp = dco_codemp
		where dco_codppl = @codppl
		and dco_tipo_partida = isnull(@tipo_partida, dco_tipo_partida)
		and hpa_coduni = isnull(@coduni, hpa_coduni)
		and hpa_coduni <> (case when @coduni_excluir is null then 0 else @coduni_excluir end)
)
select fecha_archivo_texto + '|' +
	   tipo_documento + '|' +
	   sociedad + '|' +
	   fecha_archivo_texto + '|' +
	   left(referencia_planilla + REPLICATE(space(1), 16), 16) + '|' +
	   left(fecha_texto + replicate(space(1), 25), 25) + '|' +
	   codigo_tipo_aplicacion + '|' +
	   (case when concepto_cuenta is null then concepto else left(concepto_cuenta + replicate(space(1), 10), 10) end) + '|' +
	   right(replicate(space(1), 11) + convert(varchar, coalesce(monto, 0)), 11) + '|' +
	   left(centro_costo_cuenta + replicate(space(1), 10), 10) + '|' +
	   left(unidad_administrativa + replicate(space(1), 50), 50)
	   as linea
from (
	select coalesce(@fecha_archivo_texto, 'fecha') fecha_archivo_texto,
		   coalesce(@tipo_documento, '') tipo_documento,
		   coalesce(@sociedad, '') sociedad,
		   --@fecha_archivo_texto fecha_,
		   coalesce(@referencia_planilla, 'ref') referencia_planilla,
		   coalesce(@fecha_texto, 'fectxt') fecha_texto,
		   codigo_tipo_aplicacion,
		   concepto_cuenta,
		   concepto,
		   centro_costo_cuenta,
		   unidad_administrativa,
		   monto
	from (
		select 
			   concepto_cuenta,
			   concepto,
			   centro_costo_cuenta,
			   unidad_administrativa,
			   codigo_tipo_aplicacion,
			   sum(monto) monto
		from datos
		group by concepto_cuenta, concepto, centro_costo_cuenta, unidad_administrativa, codigo_tipo_aplicacion
	) w
) v
order by concepto_cuenta, centro_costo_cuenta, unidad_administrativa, codigo_tipo_aplicacion

end

GO
