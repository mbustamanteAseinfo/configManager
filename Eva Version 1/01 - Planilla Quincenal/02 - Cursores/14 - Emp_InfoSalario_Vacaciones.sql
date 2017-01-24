/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:26 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Vacaciones';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_InfoSalario_Vacaciones','Cursor principal de la planilla de Vacaciones','SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join exp.exp_expedientes on exp_codigo = emp_codexp
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'','''',''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', '''', ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
 WHERE plz_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_fin_ppl datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

set nocount on

SELECT @fecha_fin_ppl = ppl_fecha_fin
FROM sal.ppl_periodos_planilla
WHERE ppl_codigo = @codppl

SELECT emp_codigo, 
       emp_codplz, 
       sal.valor emp_salario, 
       emp_fecha_ingreso, 
       isnull(sal.exp_valor,''Mensual'') emp_exp_salario, 
       sal.valor_hora emp_salario_hora, 
       isnull(emp_codtco, 1) emp_tipo_contrato,
       isnull(sal.valor_anterior, null) emp_ultimo_salario, 
       cast(isnull(sal.num_horas_x_mes, 208) as real) emp_num_horas_x_mes,
       plz_coduni,     
       emp_estado, 
	   isnull(gto.valor, 0) emp_gastos_representacion,
       CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida, 
	   emp_fecha_retiro fecha_retiro, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''exp_clase_renta''), ''A'') DPL_CODCLR, 
	   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''exp_numero_dependientes''), 0) DPL_NO_DEPENDIENTES_RENTA,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_marca_tarjeta''), ''N'') dpl_marca_tarjeta, 
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') dpl_suspendido,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta''), ''N'') dpl_renta,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_renta_gr''), ''N'') dpl_renta_gr,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_social''), ''N'') dpl_seguro_social,
	   isnull(gen.get_pb_field_data(emp_property_bag_data, ''emp_descuenta_seguro_educativo''), ''N'') dpl_seguro_educativo,
	   coalesce(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyuge_renta
  from exp.emp_empleos
  join exp.exp_expedientes on exp_codigo = emp_codexp
  join eor.plz_plazas on emp_codplz = plz_codigo
  join exp.fn_get_datos_rubro_salarial (null, ''S'',@fecha_fin_ppl,''pa'') sal on sal.codemp = emp_codigo and sal.codtpl = emp_codtpl
  left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin_ppl, ''pa'') gto on gto.codemp = emp_codigo and gto.codtpl = emp_codtpl
where exists
( select *
    from pa.mpv_montos_pago_vacacion where mpv_codppl = @codppl and mpv_codemp = emp_codigo
) and plz_codcia = @codcia
   and emp_estado = ''A''
   AND ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') = (CASE @codtpl WHEN 5 THEN 
																										ISNULL(gen.get_pb_field_data(emp_property_bag_data, ''emp_suspendido''), ''N'') 
																									 ELSE ''N'' END)
','emp_codigo','NingunoIncluyendo',1,0);

--Planilla Vacaciones
insert into [sal].[tpc_tipos_planilla_cursor] ([tpc_codfcu],[tpc_codtpl]) select [fcu_codigo],3 from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Vacaciones';

commit transaction;

