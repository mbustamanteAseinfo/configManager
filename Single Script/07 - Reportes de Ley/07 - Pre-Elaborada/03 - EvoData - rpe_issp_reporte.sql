IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_issp_reporte')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE [pa].[rpe_issp_reporte]
GO
CREATE PROCEDURE [pa].[rpe_issp_reporte]
	@codcia int,
	@anio int,
	@mes int
as
begin

--Ejecuta llenado de datos
------------------------------------------------
EXEC pa.proc_llena_issp @codcia, @anio, @mes --|
------------------------------------------------


declare @codtdo_isss int,
		@codtdo_cip int,
		@codtdo_pasaporte int

select @codtdo_cip = gen.get_valor_parametro_varchar('CodigoDoc_Cedula','pa',null,null,null),
	   @codtdo_isss = gen.get_valor_parametro_varchar('CodigoDoc_SeguroSocial','pa',null,null,null),
	   @codtdo_pasaporte = gen.get_valor_parametro_varchar('CodigoDoc_Pasaporte','pa',null,null,null)

-- exec [pa].[proc_llena_issp] 1, 2014, 1

-- exec pa.rpe_issp_reporte 1, 2016, 6

/*
iss_des -- cia_des
iss_licencia
iss_sector
iss_persNatu
iss_persJuri
iss_direccion
iss_telefonos
iss_representante
iss_patronal
iss_correlativo
iss_mes
iss_anio
iss_codemp
iss_isss
iss_cip
iss_observaciones
otros
iss_devengado
emp_primer_ape
emp_primer_nom
emp_sexo
pas
tc
dp
renta
renta_gr
clave
decimo
*/

select cia_descripcion iss_des,
	   coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_licencia'), '') iss_licencia,
	   tem_descripcion iss_sector,
	   rep_cip iss_persNatu,
	   coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_ruc'), '') iss_persJuri,
	   cia_direccion iss_direccion,
	   cia_telefonos iss_telefonos,
	   rep_nombre iss_representante,
	   cia_patronal iss_patronal,
	   coalesce(gen.get_pb_field_data(cia_property_bag_data, 'cia_correlativo_css'), '') iss_correlativo,
	   iss_mes,
	   iss_anio,
	   gen.lpad(convert(varchar, exp_codigo_alternativo), 5, '0') iss_codemp,
	   --coalesce((select top 1 coalesce(ide_numero, '') from exp.ide_documentos_identificacion where ide_codexp = exp_codigo and ide_codtdo = @codtdo_isss), '') iss_isss,
	   --replace(coalesce((select top 1 coalesce(ide_numero, '') from exp.ide_documentos_identificacion where ide_codexp = exp_codigo and ide_codtdo = @codtdo_cip), ''), '-', '') iss_cip,
	   --replace(coalesce((select top 1 coalesce(ide_numero, '') from exp.ide_documentos_identificacion where ide_codexp = exp_codigo and ide_codtdo = @codtdo_pasaporte), ''), '-', '') iss_pasaporte,
	   isss_sipe iss_isss,
	   replace(cip_sipe, '-', '') iss_cip,
	   iss_observaciones,
	   iss_otros otros,
	   iss_devengado,
	   exp_primer_ape emp_primer_ape,
	   exp_primer_nom emp_primer_nom,
	   exp_sexo emp_sexo,
	   (case coalesce(exp_codpai_nacimiento, '') when 'pa' then '' else 'P' end) pas,
	   iss_codigo_rubro tc,
	   '' dp,
	   iss_renta +
			   coalesce(
			   (select coalesce(Si.iss_renta, 0)
				from pa.iss_seguro Si
				where Si.iss_codcia = Se.iss_codcia
				and Si.iss_anio = Se.iss_anio
				and Si.iss_mes = Se.iss_mes
				and Si.iss_codemp = Se.iss_codemp
				and Si.iss_codigo_rubro = Se.iss_codigo_rubro
				and Si.iss_codigo_rubro <> '73'
				and Si.iss_es_decimo = (case iss_codigo_rubro when '03' then 1 else 0 end)), 0.00)
	   renta,
	   (case iss_codigo_rubro
	    when '73'
	    then iss_renta +
			   coalesce(
			   (select coalesce(Si.iss_renta, 0)
				from pa.iss_seguro Si
				where Si.iss_codcia = Se.iss_codcia
				and Si.iss_anio = Se.iss_anio
				and Si.iss_mes = Se.iss_mes
				and Si.iss_codemp = Se.iss_codemp
				and Si.iss_codigo_rubro = Se.iss_codigo_rubro
				and Si.iss_es_decimo = 1), 0.00)
	    else 0.00 end)
	   renta_gr,
	   coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_clase_renta'), '') + coalesce(gen.get_pb_field_data(exp_property_bag_data, 'exp_numero_dependientes'), '') clave,
	   coalesce(
	   (select coalesce(Si.iss_devengado, 0)
	    from pa.iss_seguro Si
	    where Si.iss_codcia = Se.iss_codcia
	    and Si.iss_anio = Se.iss_anio
	    and Si.iss_mes = Se.iss_mes
	    and Si.iss_codemp = Se.iss_codemp
	    and Si.iss_codigo_rubro = Se.iss_codigo_rubro
	    and Si.iss_es_decimo = 1), 0.00)
	   decimo
from pa.iss_seguro Se
join exp.emp_empleos
on emp_codigo = iss_codemp
join exp.exp_expedientes
on exp_codigo = emp_codexp
join eor.cia_companias
on cia_codigo = iss_codcia
left join eor.tem_tipos_empresas
on tem_codigo = cia_codtem
left join eor.plz_plazas
on plz_codigo = emp_codplz
left join eor.cdt_centros_de_trabajo
on cdt_codigo = plz_codcdt
left join (
	select rep_codcia, exp_nombres_apellidos rep_nombre, isnull(ide_cip.ide_numero, ide_pasaporte.ide_numero) rep_cip
	from eor.rep_representantes_legales
	join exp.exp_expedientes
	on exp_codigo = rep_codexp
	left join exp.ide_documentos_identificacion ide_cip
	on ide_cip.ide_codexp = exp_codigo
	and ide_cip.ide_codtdo = @codtdo_cip
	left join exp.ide_documentos_identificacion ide_pasaporte
	on ide_pasaporte.ide_codexp = exp_codigo
	and ide_pasaporte.ide_codtdo = @codtdo_pasaporte
) rep
on rep_codcia = cia_codigo
left join pa.vw_identificacion_expediente
on codexp = exp_codigo
where iss_es_decimo = 0
and iss_codcia = @codcia
and iss_anio = @anio
and iss_mes = @mes

end
