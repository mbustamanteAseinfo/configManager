
/****** Object:  StoredProcedure [rep].[constancia_sueldo]    Script Date: 07/02/2017 11:21:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC rep.constancia_sueldo '11' ,'20300'

ALTER PROCEDURE [rep].[constancia_sueldo]
            @codemp1 varchar(10),
			@alternofrimante VARCHAR(30)

			AS
			SET nocount on
			SET LANGUAGE 'Spanish'
 
 
		DECLARE  @codemp varchar(10)
		SELECT @codemp =exp_codigo_alternativo 
		FROM exp.exp_expedientes 
		WHERE exp_codigo=@codemp1
 
  
		DECLARE @nombre_emp varchar(100),@contrato varchar(20), @fecha_ingreso varchar(100),@cedula varchar(100),@unidad varchar(100),@num_ss varchar(100), @puesto varchar(100), @salario_letras varchar(255),
              @cod_mon varchar(5), @salario varchar(100),@salario_l varchar(300), @seguro_social varchar(255),@seguro_educativo varchar(255), @ir varchar(255),@nombrefrimante VARCHAR (300),@plazafirmante VARCHAR(300),
              @total_legales varchar(255), @descuentos_ciclicos varchar(max),@ingresos_ciclicos varchar(max), @total varchar(255),@total_i_ciclicos varchar(255), @fecha varchar(255)

 
		SELECT @fecha = datename([day],getdate())+' de '+datename([month],getdate())+' de '+convert(varchar(10),year(getdate()))
		SELECT @cedula=ide_numero from exp.ide_documentos_identificacion where ide_codexp=@codemp1 and ide_codtdo=10
		SELECT @num_ss=ide_numero from exp.ide_documentos_identificacion where ide_codexp=@codemp1 and ide_codtdo=11
		SELECT @unidad=uni_descripcion  from exp.emp_omniexpedientes_v where exp_codigo=@codemp1
		SELECT @nombrefrimante=exp_nombres_apellidos FROM exp.exp_expedientes where exp_codigo_alternativo = @alternofrimante
		SELECT @plazafirmante= plz_nombre
		FROM exp.emp_empleos
		JOIN exp.exp_expedientes
		ON exp_codigo = emp_codexp
		JOIN eor.plz_plazas
		ON plz_codigo = emp_codplz
		WHERE exp_codigo_alternativo = @alternofrimante
		AND emp_estado = 'A'

		SELECT @nombre_emp = (exp_nombres_apellidos),  @fecha_ingreso =datename([day],emp_fecha_ingreso)+' de '+datename([month],emp_fecha_ingreso)+' de '+convert(varchar(10),year(emp_fecha_ingreso)),
		  @puesto = (pue_nombre), @salario_letras = esa_valor,
		  @salario = esa_valor, @cod_mon = mon_simbolo, @salario_l = sal.cantidadconletras(esa_valor)
   



	FROM exp.exp_expedientes
	JOIN exp.emp_empleos on emp_codexp = exp_codigo
	JOIN eor.plz_plazas on emp_codplz = plz_codigo
	JOIN eor.pue_puestos on plz_codpue = pue_codigo
	JOIN exp.esa_est_sal_actual_empleos_v on esa_codemp = emp_codigo
	JOIN sal.tpl_tipo_planilla on emp_codtpl = tpl_codigo
	JOIN gen.mon_monedas on tpl_codmon = mon_codigo
	WHERE esa_es_salario_base = 1
	AND exp_codigo_alternativo = @codemp
 

		SELECT @contrato=tco_descripcion from exp.tco_tipos_de_contrato where tco_codigo=(select  con_codtco  from acc.con_contrataciones where con_codemp=@codemp1)


 
-- Calculo descuentos
		DECLARE @psaltotal money, @valor_renta money, @valor_isss money,@valor_isse money, @ing_afecto_isr money, @total_ciclicos money, @esPensionado bit
 
		SELECT @psaltotal = esa_valor, @esPensionado = isnull(emp_property_bag_data.value('(/DocumentElement/Empleos/esPensionado/text())[1]', 'bit'),0)

		FROM exp.exp_expedientes
		JOIN exp.emp_empleos on emp_codexp = exp_codigo
		JOIN exp.esa_est_sal_actual_empleos_v on esa_codemp = emp_codigo
		WHERE esa_es_salario_base = 1
		AND exp_codigo_alternativo = @codemp
 
		SELECT @valor_isss = gen.get_valor_parametro_money('CuotaEmpleadoSeguroSocial','pa',null,null,null)/100 * @psaltotal
                                                
		SELECT @valor_isss = isnull(@valor_isss,@psaltotal)
		SELECT @valor_isss = round(@valor_isss,2)
      

		SELECT @valor_isse = gen.get_valor_parametro_money('CuotaEmpleadoSeguroEducativo','pa',null,null,null)/100 * @psaltotal
                                                
		SELECT @valor_isse = isnull(@valor_isse,@psaltotal)
		SELECT @valor_isse = round(@valor_isse,2)
		SELECT @ing_afecto_isr = @psaltotal 
        SELECT @valor_renta = isnull(valor, 0) + (@ing_afecto_isr*13 - isnull(excedente, 0)) * round(isnull(porcentaje, 0) / 100,4)
		FROM gen.get_valor_rango_parametro('TablaRentaMensual','pa',null,null,null,@ing_afecto_isr*13)
 		SELECT @valor_renta = isnull(@valor_renta,0)
		SELECT @valor_renta = @valor_renta/13
 

 
		select @seguro_social =@valor_isss
		select @seguro_educativo =@valor_isse
		select @ir = @valor_renta
		select @total_legales = @valor_isss  + @valor_renta+ @valor_isse
 
		-- Prestamos
		declare @tdc_descripcion varchar(250), @cuota money
 
		DECLARE cursor_prestamos CURSOR FOR 
		select tdc_descripcion, dcc_valor_cuota*2
		from sal.dcc_descuentos_ciclicos 
		join exp.emp_empleos on dcc_codemp = emp_codigo
		join exp.exp_expedientes on emp_codexp = exp_codigo
		join sal.tdc_tipos_descuento on dcc_codtdc = tdc_codigo
		where exp_codigo_alternativo = @codemp
		and dcc_activo = 1
		and dcc_codtcc in (select tcc_codigo from sal.tcc_tipos_descuento_ciclico where tcc_tipo in ('Acreedores','Judiciales'))
 
		select @descuentos_ciclicos = '', @total_ciclicos = 0
 
		OPEN cursor_prestamos  
		FETCH NEXT FROM cursor_prestamos INTO @tdc_descripcion, @cuota
 
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			   select @descuentos_ciclicos = @descuentos_ciclicos + left(@tdc_descripcion + SPACE(70),70) + @cod_mon + ' ' + CAST(@cuota as varchar) + CHAR(10) + CHAR(13),
							   @total_ciclicos = @total_ciclicos + @cuota
 
			   FETCH NEXT FROM cursor_prestamos INTO @tdc_descripcion, @cuota
		END  
 
		CLOSE cursor_prestamos  
		DEALLOCATE cursor_prestamos
		 --*********************************************************ingresos detalle
		 DECLARE @ingresos_detalle TABLE
		(
		  descripcion varchar(100),
		  cuota varchar(20),
		  texto varchar(8000)
		)
 
		-- ingresos detalle
		declare @tdc_descripcion2 varchar(250), @cuota2 money,@texto varchar(8000),@total_i_cicl money
 
		set @texto = ''
		set @total_i_cicl=0
		DECLARE ingresos_detalle CURSOR FOR 
		select tig_descripcion, 
		case igc_frecuencia_cuota 
		when'Mensual' then igc_valor_cuota 
		when 'Semanal' then igc_valor_cuota*4 
		when 'Quincenal' then igc_valor_cuota*2 
		end igc_valor_cuota
		from sal.igc_ingresos_ciclicos
		join exp.emp_empleos on IGC_CODEMP = emp_codigo
		join exp.exp_expedientes on emp_codexp = exp_codigo
		join sal.tig_tipos_ingreso on igc_codtig = tig_codigo
		where emp_estado='A' and exp_codigo_alternativo = @codemp
 
		OPEN ingresos_detalle  
		FETCH NEXT FROM ingresos_detalle INTO @tdc_descripcion2, @cuota2
 
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
				  select @texto = @texto+ @tdc_descripcion2 + '  '+''+ convert(varchar,@cuota2 )
				  select @total_i_cicl=@total_i_cicl+@cuota2
			   insert into @ingresos_detalle
			   select @tdc_descripcion2, @cuota2,@texto
 
			   FETCH NEXT FROM ingresos_detalle INTO @tdc_descripcion2, @cuota2
				  select @texto = @texto+ CHAR(13)+ CHAR(10)
		  
		END  
 
		CLOSE ingresos_detalle
		DEALLOCATE ingresos_detalle

		 --******ingresos totales


		 declare @tdc_descripcionI varchar(250), @monto money
 
		DECLARE cursor_ingresos CURSOR FOR 
		select tig_descripcion, igc_valor_cuota
		from sal.igc_ingresos_ciclicos
		join exp.emp_empleos on IGC_CODEMP = emp_codigo
		join exp.exp_expedientes on emp_codexp = exp_codigo
		join sal.tig_tipos_ingreso on igc_codtig = tig_codigo
		where emp_estado='A' and exp_codigo_alternativo = @codemp

 
		select @ingresos_ciclicos = '', @ingresos_ciclicos = 0
 
		OPEN cursor_ingresos  
		FETCH NEXT FROM cursor_ingresos INTO @tdc_descripcionI, @monto
 
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			   select @ingresos_ciclicos = @ingresos_ciclicos + left(@tdc_descripcionI + SPACE(70),70) + @cod_mon + 'B/.' + CAST(@monto as varchar) + CHAR(10) + CHAR(13),
							   @total_i_ciclicos = @total_i_ciclicos + @monto
 
			   FETCH NEXT FROM cursor_ingresos INTO @tdc_descripcionI, @monto
		END  
 
		CLOSE cursor_ingresos 
		DEALLOCATE cursor_ingresos



		 --*************************************************
		 DECLARE @prestamos2 TABLE
		(
		  descripcion varchar(100),
		  cuota varchar(20),
		  texto varchar(8000)
		)
 
		-- Prestamos
		declare @tdc_descripcion3 varchar(250), @cuota3 money,@texto3 varchar(8000)
 
		set @texto3 = ''
		DECLARE cursor_prestamos2 CURSOR FOR 
		select tdc_descripcion, dcc_valor_cuota
		from sal.dcc_descuentos_ciclicos
		join exp.emp_empleos on dcc_codemp = emp_codigo
		join exp.exp_expedientes on emp_codexp = exp_codigo
		join sal.tdc_tipos_descuento on dcc_codtdc = tdc_codigo
		where exp_codigo_alternativo = @codemp
		and dcc_activo = 1
		and dcc_codtcc in (select tcc_codigo from sal.tcc_tipos_descuento_ciclico where tcc_tipo in ('Acreedores','Judiciales'))
 
		OPEN cursor_prestamos2  
		FETCH NEXT FROM cursor_prestamos2 INTO @tdc_descripcion2, @cuota2
 
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
				  select @texto3 = @texto3+ @tdc_descripcion2 + '  '+ 'B/.'+convert(varchar,@cuota2*2 )
			   insert into @prestamos2
			   select @tdc_descripcion2, @cuota2,@texto3
 
			   FETCH NEXT FROM cursor_prestamos2 INTO @tdc_descripcion2, @cuota2
				  select @texto3 = @texto3+ CHAR(13)+ CHAR(10)
		END  
 
		CLOSE cursor_prestamos2  
		DEALLOCATE cursor_prestamos2
 
		 --*******************



		select @total = CAST(@total_legales as money) + @total_ciclicos

		select  @nombrefrimante nombrefirmante,@plazafirmante plazafirmante,@nombre_emp nombre, @puesto plaza,@contrato tipo_contrato,
				  ' '+@salario salario,@salario_l salario_l, ' '+@seguro_social seguro_social, ' '+@ir ir,@cedula cedula,@num_ss num_ss,@fecha_ingreso inicio,' '+ @seguro_educativo seguro_e,
				  @total_legales total_legales, @cod_mon cod_mon,' '+ @total total,@unidad unidad,  ' '+convert(varchar,round(@total_ciclicos,2,0)) total_ciclicos,
				  @fecha fecha,(select top 1 @texto3  from @prestamos2)as detalle,(select top 1 @texto  from @ingresos_detalle)as detalle_i,' '+@total_i_cicl ingresos
		
