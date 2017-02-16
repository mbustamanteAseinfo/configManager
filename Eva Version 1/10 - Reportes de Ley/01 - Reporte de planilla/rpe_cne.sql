
GO
/****** Object:  StoredProcedure [pa].[rpe_cne]    Script Date: 07/02/2017 8:42:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_cne]
	@codcia int,
	@codtpl int,
	@codpla varchar(50),
	@codcco int = null
as
begin

set nocount on
set dateformat dmy

declare @codppl int,
		@coduni int,
		@codemp int

set @coduni = null
set @codemp = null

select @codppl = ppl_codigo
	from sal.ppl_periodos_planilla
	join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	join gen.mon_monedas on mon_codigo = tpl_codmon
where tpl_codcia = @codcia
	and tpl_codigo = @codtpl
	and ppl_codigo_planilla = @codpla

declare @rpe_nombre_empresa varchar(150),
		@rpe_fecha_ini datetime,
		@rpe_fecha_fin datetime,
		@rpe_fecha_pago datetime,
		@rpe_anio_cont int,
		@rpe_mes_cont int,
		@rpe_estado varchar(15),
		@nombre_mes varchar(10),
		@codigo_planilla varchar(10),
		@rpe_desc_planilla varchar(50),
		@rpe_codemp int,
		@fetch_emp int

declare @nombre_emp varchar(257),
		@nombre_plz varchar(100),
		@nombre_uni varchar(80),
		@valor_hora numeric(12,4),
		@valor numeric(12,2),
		@fecha_ingreso varchar(10),
		@cedula varchar(30),
		@codexp_alternativo varchar(36),
		@horas_periodo numeric(10,4)

declare @contador int,
		@contador1 int,
		@rpe_no_recibo int,
		@contador_lineas int
		
declare @rpe_codtipo int,
		@rpe_nombre_tipo varchar(150),
		@rpe_percepcion numeric(12,2),
		@rpe_tiempo numeric(10,2),
		@rpe_orden smallint

declare @rpe_codigo_deduccion int,
		@rpe_desc_deduccion varchar(150),
		@rpe_deduccion numeric(12,2),
		@orden smallint,
		@rpe_coduni int,
		@rpe_codtpl int,
		@rpe_unidad varchar(80),
		@rpe_centro_costo varchar(100)

declare @codtdo_cedula int

select @codtdo_cedula = gen.get_valor_parametro_int('CodigoDoc_Cedula', 'pa', null, null, null)

create table #recibos (
	rpe_codemp int,
	rpe_nombre_empleado varchar(257),
	rpe_puesto varchar(100),
	rpe_salario_hora numeric(12,4),
	rpe_no_recibo int,
	rpe_codtipo int,
	rpe_nombre_tipo varchar(150),
	rpe_tiempo numeric(10,2),
	rpe_codigo_deduccion int,
	rpe_desc_deduccion varchar(150),
	rpe_percepcion numeric(19,4),
	rpe_valor_deduccion numeric(19,4),
	rpe_fecha_ingreso varchar(10),
	rpe_cedula varchar(30),
	rpe_orden int,
	rpe_orden_tdc int,
	rpe_codemp_anterior varchar(36),
	rpe_num_horas_x_bisemana numeric(10,4),
	rpe_anio_cont int,
	nombre_mes varchar(10),
	rpe_coduni int,
	rpe_unidad varchar(80),
	rpe_centro_costo varchar(100)
)

select @rpe_nombre_empresa = cia_descripcion,
	   @rpe_fecha_ini = ppl_fecha_ini,
	   @rpe_fecha_fin = ppl_fecha_fin,
	   @rpe_fecha_pago = ppl_fecha_pago,
	   @rpe_anio_cont = ppl_anio,
	   @rpe_mes_cont = ppl_mes,
	   @rpe_estado = ppl_estado,
	   @nombre_mes = gen.nombre_mes(ppl_mes),
	   @codigo_planilla = ppl_codigo_planilla,
	   @rpe_desc_planilla = tpl_descripcion,
	   @rpe_codtpl = tpl_codigo
from sal.ppl_periodos_planilla
join sal.tpl_tipo_planilla
on tpl_codigo = ppl_codtpl
join eor.cia_companias
on cia_codigo = tpl_codcia
where ppl_codigo = @codppl

declare c_emp cursor for
select distinct emp_codigo,
	   exp_apellidos_nombres nombre_empleado,
	   plz_nombre pue_nombre,
	   uni_descripcion,
	   ese_valor_hora,
	   convert(varchar, emp_fecha_ingreso, 103),
	   cedulas.ide_numero ide_cip,
	   exp_codigo_alternativo,
	   0 emp_num_horas_x_bisemana,
	   uni_codigo,
	   uni_descripcion,
	   cco_descripcion
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codexp
join (select distinct inn_codemp
	  from sal.inn_ingresos
	  where inn_codppl = @codppl
	  and inn_codemp = coalesce(@codemp, inn_codemp)
	  and inn_valor > 0) planilla
on planilla.inn_codemp = emp_codigo
join eor.plz_plazas
on plz_codigo = emp_codplz
join eor.uni_unidades
on uni_codigo = plz_coduni
left join (
	select ide_codexp, ide_numero
	from exp.ide_documentos_identificacion
	where ide_codtdo = @codtdo_cedula
) cedulas
on cedulas.ide_codexp =  exp_codigo
join exp.ese_estructura_sal_empleos
on ese_codemp = emp_codigo
join exp.rsa_rubros_salariales
on rsa_codigo = ese_codrsa
and rsa_es_salario_base = 1
left join eor.cpp_centros_costo_plaza
on cpp_codplz = emp_codplz
left join eor.cco_centros_de_costo
on cco_codigo = cpp_codcco
where ese_estado = 'V'
and emp_codigo = coalesce(@codemp, emp_codigo)
and uni_codigo = coalesce(@coduni, uni_codigo)
and coalesce(cco_codigo, 0) = coalesce(@codcco, coalesce(cco_codigo, 0))
order by cco_descripcion, exp_apellidos_nombres

open c_emp
fetch c_emp into @rpe_codemp, @nombre_emp, @nombre_plz, @nombre_uni,
				 @valor_hora, @fecha_ingreso,
				 @cedula, @codexp_alternativo,
				 @horas_periodo, @rpe_coduni, @rpe_unidad,
				 @rpe_centro_costo
set @fetch_emp = @@FETCH_STATUS

while @fetch_emp = 0
begin
	
	/******************************************************/
	SELECT @contador = count(*)
	FROM sal.dss_descuentos
	WHERE dss_codppl = @codppl
	and dss_codemp = @rpe_codemp
	
	SELECT @contador1 = count(*)
	FROM sal.inn_ingresos
	WHERE inn_codppl = @codppl
	and inn_codemp = @rpe_codemp
	
	SELECT @contador_lineas = 0
	SELECT @rpe_no_recibo = @contador
	
	DECLARE c_ing CURSOR FOR
	SELECT tig_codigo,
		   tig_descripcion,
		   round(inn_valor,2),
		   inn_tiempo inn_dias_ingreso,
		   tig_orden
	FROM sal.inn_ingresos
	join sal.tig_tipos_ingreso
	on tig_codigo = inn_codtig
	WHERE inn_codppl = @codppl
	and inn_codemp = @rpe_codemp
	--and inn_valor > 0
	ORDER BY tig_orden
	
	OPEN c_ing
	
	--Rutina para establecer los codigos y descripciones para los descuentos  		 
	DECLARE c_desc CURSOR FOR 
	SELECT tdc_codigo,
		   tdc_descripcion,
		   sum(round(dss_valor,2)) dss_valor,
		   isnull(tdc_orden,990)
	--, cast(isnull(dss_dias_descuento,0) as real)
	FROM sal.dss_descuentos
	join sal.tdc_tipos_descuento
	on dss_codtdc = tdc_codigo
	WHERE dss_codppl = @codppl
	and dss_codemp = @rpe_codemp
	and dss_valor > 0
	--and (not exists (SELECT tpr_codtdc,
	--						isnull(bco_nombre,''),
	--						round(cdc_val_cuota - isnull(cdc_val_nopagado,0),2) dss_valor,
	--						isnull(tdc_orden,990)
	--				 FROM  pla_cdc_cuotas_desc,
	--					   pla_pre_prestamo,
	--					   pla_tpr_tipo_prestamo,
	--					   pla_tdc_tipo_descuento,
	--					   pla_bco_banco
	--				 WHERE cdc_codcia = dss_codcia 
	--				 and cdc_codtpl = dss_codtpl
	--				 and cdc_codpla = dss_codpla
	--				 and cdc_codemp = dss_codemp
	--				 and tpr_codtdc = dss_codtdc
	--				 and cdc_val_cuota > 0
	--				 and cdc_aplicada = 'S'
	--				 and pre_codcia = cdc_codcia
	--				 and pre_codigo = cdc_codpre
	--				 and pre_codemp = cdc_codemp
	--				 and bco_codigo = pre_codbco
	--				 and tpr_codigo = pre_codtpr
	--				 and tpr_codcia = pre_codcia
	--				 and tdc_codcia = tpr_codcia
	--				 and tdc_codigo = tpr_codtdc 
	--				)
	--	)
	--UNION ALL
	--SELECT tpr_codtdc,/*isnull(bco_nombre,'')*/
	--	   TDC_DESCRIPCION,
	--	   round(cdc_val_cuota - isnull(cdc_val_nopagado,0),2) dss_valor,
	--	   isnull(tdc_orden,990)
	--FROM pla_cdc_cuotas_desc,
	--	 pla_pre_prestamo,
	--	 pla_tpr_tipo_prestamo,
	--	 pla_tdc_tipo_descuento,
	--	 pla_bco_banco
	--WHERE cdc_codcia = @codcia
	--and cdc_codtpl = @codtpl
	--and cdc_codpla = @codpla
	--and cdc_codemp = @rpe_codemp
	--and cdc_val_cuota > 0
	--and cdc_aplicada = 'S'
	--and pre_codcia = cdc_codcia
	--and pre_codigo = cdc_codpre
	--and pre_codemp = cdc_codemp
	--and bco_codigo = pre_codbco
	--and tpr_codigo = pre_codtpr
	--and tpr_codcia = pre_codcia
	--and tdc_codcia = tpr_codcia
	--and tdc_codigo = tpr_codtdc 
	group by tdc_codigo, tdc_descripcion, isnull(tdc_orden,990)
	ORDER BY 4
	
	SELECT @contador = CASE WHEN @contador > @contador1 THEN @contador ELSE @contador1 END
	
	OPEN c_desc
	
	WHILE @contador_lineas < 25 -- @contador
	BEGIN
		SELECT @contador_lineas = @contador_lineas + 1  
		
		FETCH NEXT FROM c_ing INTO @rpe_codtipo,@rpe_nombre_tipo,
								   @rpe_percepcion,@rpe_tiempo,
								   @rpe_orden
		IF @@FETCH_STATUS <> 0		
		BEGIN
			SELECT @rpe_codtipo = null,@rpe_nombre_tipo = null,
				   @rpe_percepcion = null,@rpe_tiempo = null
		END
		
		FETCH NEXT FROM c_desc INTO @rpe_codigo_deduccion,
									@rpe_desc_deduccion,
									@rpe_deduccion, @orden
		
		IF @@FETCH_STATUS <> 0	
		BEGIN
			SELECT @rpe_codigo_deduccion = null,
				   @rpe_desc_deduccion = null,
				   @rpe_deduccion = null,
				   @orden = null
		END
		
		insert into #recibos
			   (rpe_codemp, rpe_nombre_empleado,
			    rpe_puesto, rpe_salario_hora,
			    rpe_no_recibo, rpe_codtipo,
			    rpe_nombre_tipo, rpe_tiempo,
			    rpe_codigo_deduccion, rpe_desc_deduccion,
			    rpe_percepcion, rpe_valor_deduccion,
			    rpe_fecha_ingreso, rpe_cedula,
			    rpe_orden, rpe_orden_tdc,
			    rpe_codemp_anterior, rpe_num_horas_x_bisemana,
			    rpe_anio_cont,
			    nombre_mes, rpe_coduni, rpe_unidad,
			    rpe_centro_costo
			    )
		values (@rpe_codemp, @nombre_emp,
			   @nombre_plz, @valor_hora,
			   @rpe_no_recibo, @rpe_codtipo,
			   @rpe_nombre_tipo, @rpe_tiempo,
			   @rpe_codigo_deduccion, @rpe_desc_deduccion,
			   @rpe_percepcion, @rpe_deduccion,
			   @fecha_ingreso, @cedula,
			   @rpe_orden, @orden,
			   @codexp_alternativo, @horas_periodo,
			   @rpe_anio_cont,
			   @nombre_mes, @rpe_coduni, @rpe_unidad,
			   @rpe_centro_costo)
			   
		SELECT @rpe_codtipo = null
		SELECT @rpe_nombre_tipo = null
		SELECT @rpe_percepcion = null			
		SELECT @rpe_tiempo = null		
		SELECT @rpe_codigo_deduccion = null
		SELECT @rpe_desc_deduccion = null
	END
	
	CLOSE c_desc
	DEALLOCATE c_desc
	
	CLOSE c_ing
	DEALLOCATE c_ing

	/******************************************************/

	fetch c_emp into @rpe_codemp, @nombre_emp,
					 @nombre_plz, @nombre_uni,
					 @valor_hora, @fecha_ingreso,
					 @cedula, @codexp_alternativo,
					 @horas_periodo, @coduni, @rpe_unidad,
					 @rpe_centro_costo
	set @fetch_emp = @@FETCH_STATUS
end
close c_emp
deallocate c_emp

select *,
	   @rpe_nombre_empresa rpe_nombre_empresa,
	   @codigo_planilla rpe_codpla,
	   @rpe_fecha_ini rpe_fecha_ini,
	   @rpe_fecha_fin rpe_fecha_fin,
	   @rpe_estado rpe_estado,
	   @rpe_fecha_pago rpe_fecha_pago,
	   @rpe_desc_planilla rpe_desc_planilla,
	   @rpe_codtpl rpe_codtpl
from #recibos

drop table #recibos

end
