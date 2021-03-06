IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rep_recibo_pago')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE [pa].[rep_recibo_pago]
GO
CREATE PROCEDURE [pa].[rep_recibo_pago]
			@codcia smallint = null,
			@codtpl smallint = null,
			@CodigoPlanilla varchar(20)	= null,			
			@codexp int = null,
			@codcdt int = null,
			@IgnorarConCorreo varchar = null
as

-- exec [pa].[rep_recibo_pago] 1, 2, '20160801'

set nocount on

declare @codppl int, @MonedaPlanilla varchar(5), @codemp int, @fechaFin datetime

select @codppl = ppl_codigo,	
	  @MonedaPlanilla = mon_simbolo,
	  @fechaFin = ppl_fecha_fin
	from sal.ppl_periodos_planilla
	join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
	join gen.mon_monedas on mon_codigo = tpl_codmon
where tpl_codcia = @codcia
	and tpl_codigo = @codtpl
	and ppl_codigo_planilla = @codigoplanilla

--*
--* Variables para Estado de Cuenta de Vacaciones
--*
Declare @pfRetiro varchar(10),					@panterior int,						@pgozados int, 
		@pnuevos real,							@pfecha_ingreso datetime,			@leyenda_Vacacion varchar(255),
		@leyenda_Vacacion2 varchar(255),		@leyenda_Vacacion3 varchar(255)		
--*
--* Busca los empleados que tuvieron ingresos en la planilla selecionada
--*


declare c_emp cursor for
select emp_codigo, 
	exp_codigo,
	exp_apellidos_nombres,
	plz_codigo,
	plz_nombre,
	uni_descripcion,
	isnull(hpa_salario,esa_valor) Salario,
	mon_simbolo MonedaSalario,  
	(cco_nomenclatura_contable + ' ' + cco_descripcion)  centro_nombre,
	cdt_descripcion
from exp.emp_empleos
	join exp.exp_expedientes on exp_codigo = emp_codexp	
	join (select distinct inn_codemp
			from sal.inn_ingresos
			where inn_codppl = @codppl				
				and inn_valor > 0) f1 on emp_codigo = f1.inn_codemp
	left outer join sal.hpa_hist_periodos_planilla on hpa_codemp = emp_codigo and hpa_codppl = @codppl
	join eor.plz_plazas on plz_codigo = isnull(emp_codplz, hpa_codplz)
	join eor.pue_puestos on plz_codpue = isnull(pue_codigo, hpa_codpue)
	join eor.uni_unidades on plz_coduni = isnull(uni_codigo,hpa_coduni) 	
	left outer join (select cpp_codplz, max(cpp_codcco) cpp_codcco from eor.cpp_centros_costo_plaza 
				group by cpp_Codplz) CentrosPorPlaza on cpp_codplz= plz_codigo
	left outer join eor.cco_centros_de_costo on cco_codigo = cpp_codcco
	join eor.cdt_centros_de_trabajo on cdt_codigo = plz_codcdt
	join exp.esa_est_sal_actual_empleos_v on esa_codemp = emp_codigo and esa_es_salario_base = 1
	join gen.mon_monedas on mon_codigo = isnull(hpa_codmon,esa_Codmon)
		
where plz_codcia = @codcia
	and exp_codigo = isnull(@codexp,exp_codigo)	
	and plz_codcdt = isnull(@codcdt,plz_codcdt)
	and isnull(exp_email_interno,'1') = case when isnull(@IgnorarConCorreo,'0') = '1' then '1' else  isnull(exp_email_interno,'1') end

order by uni_descripcion, (cco_nomenclatura_contable + ' ' + cco_descripcion), emp_codigo


--*
--* declaraciones de Variables de la tabla o del cursor
--*
  declare 
	@rpe_nombre_empresa  varchar(250),					@rpe_fecha_ini       datetime,						@rpe_fecha_fin       datetime,
	@rpe_codemp          int,							@rpe_nombre_empleado varchar(250),					@rpe_codpue    	   int,
	@rpe_puesto   	   varchar(250),					@unidad      varchar(200),							@rpe_nit             varchar(12),
	@rpe_isss            varchar(12),					@rpe_forma_pago          varchar(12),				@rpe_salario_hora          real,
	@rpe_salario          real,							@rpe_no_recibo       int,							@rpe_codtipo         int,
	@rpe_nombre_tipo     varchar(50),					@rpe_tasa real ,@rpe_tiempo          real,							@rpe_percepcion      real,
	@rpe_deduccion       real,							@rpe_saldo_prest     real,							@contador int, 
	@dias_notrabajados int,								@Ppre_monto float,									@PTotal float, 
	@Pdiasincapacidad int,								@PdiasTrabajados int,								@Pdiasdomingos int, 
	@PdiasFeriado int,									@PinnTasa real,										@Pdiasvac int, 
	@rpe_desc_deduccion varchar(50),					@rpe_valor_deduccion real,							@rpe_codigo_deduccion int,
	@orden int,											@contador_lineas int,								@centro_nombre varchar(150), 
	@afp varchar(100),									@area varchar(200),									@ubicacion varchar(100),
	@rpe_distribucion varchar(100),						@rpe_orden int,										@rpe_orden_tdc int,
	@dias_desc real,									@rpe_distribucion_total varchar(100),				@rpe_unidad_tiempo varchar(15),
	@rpe_codexp int,									@rpe_moneda varchar(5)								

	

Select  
	@dias_notrabajados = 0,								@pdiasincapacidad = 0,								@PdiasTrabajados = 0, 
	@PdiasFeriado = 0,									@Pdiasvac = 0

select @rpe_nombre_empresa = cia_descripcion
from eor.cia_companias
where cia_codigo = @codcia

	select @rpe_fecha_ini = ppl_fecha_ini,
		@rpe_fecha_fin = ppl_fecha_fin,
		@pfRetiro = convert(varchar, ppl_fecha_fin, 103)
	from sal.ppl_periodos_planilla 
	where ppl_codigo = @codppl


-- Creacion Tabla Temporal de Recibos
--
CREATE TABLE #recibos (
	rpe_codcia int NULL ,								rpe_nombre_empresa varchar (250)  NULL ,			rpe_codtpl int NULL ,
	rpe_codpla varchar(20) NULL ,								rpe_fecha_ini datetime NULL ,						rpe_fecha_fin datetime NULL ,
	rpe_codexp int,										rpe_codemp int NULL ,								rpe_nombre_empleado varchar (250)  NULL ,			
	rpe_codpue int NULL ,
	rpe_puesto varchar (250)  NULL ,					rpe_unidad varchar (200)  NULL ,					rpe_nit varchar (12)  NULL ,
	rpe_isss varchar (12)  NULL ,						rpe_forma_pago varchar (12)  NULL ,					rpe_salario_hora real NULL ,
	rpe_salario real NULL ,								rpe_no_recibo int NULL ,							rpe_codtipo int NULL ,
	rpe_moneda varchar(5),								rpe_unidad_tiempo varchar(15),
	rpe_nombre_tipo varchar (50)  NULL ,				rpe_tasa real NULL, rpe_tiempo real NULL ,			rpe_percepcion real NULL ,
	rpe_deduccion real NULL ,							rpe_saldo_prest real NULL ,							rpe_dias_notrabajados int NULL ,
	rpe_dias_incapacidad int NULL ,						rpe_dias_trabajados int NULL ,						rpe_dias_domingos int NULL ,
	rpe_dias_feriados int NULL ,						rpe_dias_vac int NULL ,								rpe_desc_deduccion varchar (50)  NULL ,
	rpe_valor_deduccion real NULL ,						rpe_codigo_deduccion int NULL ,						rpe_contador_ing int NULL ,
	rpe_mensaje varchar (250)  NULL ,					rpe_centro_nombre varchar (150)  NULL ,				afp varchar (100)  NULL ,
	rpe_area varchar (250)  NULL ,						rpe_vacacion_leyenda varchar(255) null,				rpe_vacacion_leyenda2 varchar(255) null,
	rpe_vacacion_leyenda3 varchar(255) null,			rpe_ubicacion varchar(100),							rpe_distribucion varchar(100),
	rpe_orden int,										rpe_orden_tdc int,									rpe_dias_desc real,
	rpe_distribucion_total varchar(100)
)
select @contador = 1

OPEN c_emp
	FETCH NEXT FROM c_emp
	INTO  
	@rpe_codemp,@rpe_codexp,@rpe_nombre_empleado,@rpe_codpue,@rpe_puesto,@unidad,
	@rpe_salario,@rpe_moneda,@centro_nombre,@ubicacion



	WHILE @@FETCH_STATUS = 0
	BEGIN
		select @contador_lineas = 0
		select @rpe_no_recibo = @contador
		
--- Obtengo Informacion de Vacaciones
	set @leyenda_Vacacion = null						Set @leyenda_vacacion2= null						Set @leyenda_vacacion3= null
	Set @pFecha_Ingreso=null							Set @panterior = 0									Set @pgozados = 0
	Set @pnuevos = 0
		

	declare c_ing cursor for
		select tig_codigo,
			tig_descripcion,
			round(inn_valor,2),			 
				inn_tiempo ,
				inn_unidad_tiempo,
			isnull(tig_orden,990) tig_orden			
		from sal.inn_ingresos
			join sal.tig_tipos_ingreso on inn_codtig = tig_codigo
		where inn_codppl = @codppl
			and inn_codemp = @rpe_codemp and inn_valor > 0 ---order by tig_orden

	OPEN c_ing

	declare c_desc cursor for
		select tdc_codigo,
			tdc_descripcion,round(dss_valor,2) dss_valor, isnull(tdc_orden,990),cast(isnull(dss_tiempo,0) as real)
		from sal.dss_descuentos
			join sal.tdc_tipos_descuento on dss_codtdc = tdc_codigo
		where dss_codppl = @codppl
			and dss_codemp = @rpe_codemp
			and dss_valor > 0

	OPEN c_desc
                     
	WHILE @contador_lineas < 14
		begin
		select @contador_lineas = @contador_lineas + 1
			
		FETCH NEXT FROM c_ing
		INTO @rpe_codtipo,@rpe_nombre_tipo,
		@rpe_percepcion,@rpe_tiempo,@rpe_unidad_tiempo,@rpe_orden
			
		if @@FETCH_STATUS <> 0		
			begin
				select @rpe_codtipo = null,@rpe_nombre_tipo = null,
					@rpe_percepcion = null,@rpe_tasa=null,@rpe_tiempo = null, @rpe_unidad_tiempo = null
			end

		FETCH NEXT FROM c_desc
		INTO @rpe_codigo_deduccion,@rpe_desc_deduccion,
		@rpe_deduccion, @orden,@dias_desc

		if @@FETCH_STATUS <> 0	
			begin			
				select @rpe_codigo_deduccion = null,@rpe_desc_deduccion = null,
			  	@rpe_deduccion = null, @orden = null
			end


					
				insert into #recibos (
							rpe_codcia,						rpe_nombre_empresa,								rpe_codtpl,
							rpe_codpla,						rpe_fecha_ini,									rpe_fecha_fin,
							rpe_codemp,						rpe_nombre_empleado,							rpe_codpue,
							rpe_codexp,
							rpe_puesto,						rpe_unidad,										rpe_nit,
							rpe_isss,						rpe_forma_pago,									rpe_salario_hora,	
							rpe_salario,					rpe_no_recibo,									rpe_codtipo,
							rpe_moneda,
							rpe_nombre_tipo,				rpe_tasa,										rpe_tiempo,
							rpe_unidad_tiempo,				rpe_codigo_deduccion,
							rpe_desc_deduccion,				rpe_percepcion,									rpe_valor_deduccion,
							rpe_saldo_prest,				rpe_centro_nombre,								afp, 
							rpe_area,						rpe_vacacion_leyenda,							rpe_vacacion_leyenda2, 
							rpe_vacacion_leyenda3,			rpe_ubicacion,									rpe_distribucion,
							rpe_orden,						rpe_orden_tdc,									rpe_dias_desc,
							rpe_distribucion_total
							)
			        values (
							@codcia,						@rpe_nombre_empresa,							@codtpl,
							@CodigoPlanilla,						@rpe_fecha_ini,									@rpe_fecha_fin,
							@rpe_codemp,					@rpe_nombre_empleado,							@rpe_codpue,
							@rpe_codexp,
							@rpe_puesto,					@unidad,										@rpe_nit,
							@rpe_isss,						@rpe_forma_pago,								@rpe_salario_hora,
							@rpe_salario,					@rpe_no_recibo,									@rpe_codtipo,
							@rpe_moneda,
							@rpe_nombre_tipo,				@rpe_tasa,										@rpe_tiempo,
							@rpe_unidad_tiempo,				@rpe_codigo_deduccion,
							@rpe_desc_deduccion,			@rpe_percepcion,								@rpe_deduccion,
							@rpe_saldo_prest,				@centro_nombre,									@afp, 
							@area,							@leyenda_Vacacion,								@leyenda_Vacacion2,
							@leyenda_Vacacion3,				@ubicacion,										@rpe_distribucion,
							isnull(@rpe_orden,990),			isnull(@orden,990),								@dias_desc,
							@rpe_distribucion_total
							)
			set @rpe_codtipo = null						set @rpe_nombre_tipo = null					set @rpe_percepcion = null
			set @rpe_orden = null						set @orden = null							set @rpe_tasa = null set @rpe_tiempo = null
			set @dias_desc = null						set @rpe_codigo_deduccion = null				set @rpe_desc_deduccion = null
			set @rpe_unidad_tiempo = null
        END

	CLOSE c_desc
	DEALLOCATE c_desc
	CLOSE c_ing
	DEALLOCATE c_ing

FETCH NEXT FROM c_emp
INTO 
@rpe_codemp,@rpe_codexp,@rpe_nombre_empleado,@rpe_codpue,@rpe_puesto,@unidad,
@rpe_salario,@rpe_moneda,@centro_nombre,@ubicacion




select @contador = @contador + 1

END

CLOSE c_emp
DEALLOCATE c_emp
      
select 
	rpe_codcia,							rpe_nombre_empresa,							rpe_codpla,rpe_codtpl,
	rpe_fecha_ini,						rpe_fecha_fin,								rpe_codemp,
	rpe_codexp,
	rpe_nombre_empleado,				rpe_codpue,									rpe_puesto,
	rpe_unidad,							rpe_nit,rpe_isss,							rpe_forma_pago,
	rpe_salario_hora,					rpe_salario,								rpe_no_recibo,
	rpe_moneda,
	rpe_codtipo,						rpe_nombre_tipo,							rpe_tasa, rpe_tiempo,rpe_unidad_tiempo,
	rpe_percepcion,						rpe_deduccion,								rpe_saldo_prest,
	rpe_desc_deduccion,					rpe_valor_deduccion,						rpe_codigo_deduccion,
	rpe_or,								rpe_tipo,									rpe_centro_nombre,
	afp,								rpe_area,									rpe_vacacion_leyenda,
	rpe_vacacion_leyenda2,				rpe_vacacion_leyenda3,						rpe_ubicacion,
	rpe_distribucion,					rpe_orden,									rpe_orden_tdc,
	rpe_dias_desc,						rpe_distribucion_total,						gen.fn_crufl_FechaALetras(rpe_fecha_fin,0,0) rpe_fecha_fin_letras,
	@MonedaPlanilla MonedaPlanilla
From       
(
    select 
		rpe_codcia,							rpe_nombre_empresa,							rpe_codpla,rpe_codtpl,
		rpe_fecha_ini,						rpe_fecha_fin,								rpe_codemp,
		rpe_codexp,
		rpe_nombre_empleado,				rpe_codpue,									rpe_puesto,
		rpe_unidad,							rpe_nit,									rpe_isss,
		rpe_forma_pago,						rpe_salario_hora,							rpe_salario,
		rpe_moneda,
		rpe_no_recibo,						rpe_codtipo,								rpe_nombre_tipo,rpe_tasa,
		rpe_tiempo,							rpe_unidad_tiempo,							rpe_percepcion,
		rpe_deduccion,
		rpe_saldo_prest,					rpe_desc_deduccion,							rpe_valor_deduccion,
		rpe_codigo_deduccion,				1 rpe_or,									'ORIGINAL - ARCHIVO' rpe_tipo,
		rpe_centro_nombre,					afp,										rpe_area,
		rpe_vacacion_leyenda,				rpe_vacacion_leyenda2,						rpe_vacacion_leyenda3,
		rpe_ubicacion,						rpe_distribucion,							rpe_orden,rpe_orden_tdc,
		case when rpe_dias_desc = 0 then 
			'' else 
			cast(rpe_dias_desc as varchar) 
		end rpe_dias_desc,					rpe_distribucion_total
	from #recibos 
	--where len(isnull(rpe_nombre_tipo, '') + isnull(rpe_desc_deduccion, '')) > 0
 ) t
--where len(isnull(rpe_nombre_tipo, '') + isnull(rpe_desc_deduccion, '')) > 0
order by rpe_centro_nombre,rpe_codemp,rpe_orden asc
-- rpe_nombre_tipo
-- rpe_desc_deduccion

drop TABLE #recibos 
return
