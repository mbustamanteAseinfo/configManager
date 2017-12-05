/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:25 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_InfoSalario_Ajustes';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_InfoSalario_Ajustes','Cursosr principal de la planilla de Ajustes','SELECT emp_codigo,
   emp_estado,
   emp_codplz,
   emp_fecha_ingreso,
   emp_codtco,
   plz_coduni,
   CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida,
   emp_fecha_retiro,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''ClaseRenta''), '''') dpl_codclr,
   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''NumeroDependientes''), 0) dpl_no_dependientes_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''MarcaTarjeta''), cast(0 as bit)) dpl_marca_tarjeta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''esSuspendido''), cast(0 as bit)) dpl_suspendido,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DescuentaRenta''), cast(1 as bit)) dpl_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyugue_renta,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''TipoAplicacionRenta''), ''P'') dpl_tipo_aplicacion_renta,
   ''PAB'' codmon
FROM exp.emp_empleos
join eor.plz_plazas
on plz_codigo = emp_codplz
join exp.esa_est_sal_actual_empleos_v
on esa_codemp = emp_codigo
where 1 = 2
','declare @codcia int, @codppl int, @codpai varchar(2), @fecha_fin_ppl datetime, @codtpl int, @fecha_ini_ppl datetime, @FRECUENCIA INT, @codmon varchar(3)

SET @codcia = $$CODCIA$$
SET @codppl = $$CODPPL$$
SET @codtpl = $$CODTPL$$ 

set nocount on 

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

SELECT @fecha_fin_ppl = ppl_fecha_fin,@fecha_ini_ppl = ppl_fecha_ini, @FRECUENCIA = PPL_FRECUENCIA, @codmon=tpl_codmon
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
WHERE ppl_codigo = @codppl

SELECT emp_codigo, 
   emp_estado,
   emp_codplz,
   emp_fecha_ingreso,
   emp_codtco,
   plz_coduni,
   CASE WHEN plz_fecha_fin IS NULL THEN 1 ELSE 0 END plz_indefinida,
   emp_fecha_retiro,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''ClaseRenta''), '''') dpl_codclr,
   isnull(gen.get_pb_field_data_int(emp_property_bag_data, ''NumeroDependientes''), 0) dpl_no_dependientes_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''MarcaTarjeta''), cast(0 as bit)) dpl_marca_tarjeta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''esSuspendido''), cast(0 as bit)) dpl_suspendido,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DescuentaRenta''), cast(1 as bit)) dpl_renta,
   isnull(gen.get_pb_field_data_bit(emp_property_bag_data, ''DependeConyugueRenta''), cast(0 as bit)) dpl_depende_conyugue_renta,
   isnull(gen.get_pb_field_data(emp_property_bag_data, ''TipoAplicacionRenta''), ''P'') dpl_tipo_aplicacion_renta,
   @codmon codmon
FROM exp.emp_empleos
join eor.plz_plazas on plz_codigo = emp_codplz
join exp.fn_get_datos_rubro_salarial(NULL, ''S'', @fecha_fin_ppl, @codpai)  sal on sal.codemp = emp_codigo
left join exp.fn_get_datos_rubro_salarial(NULL, ''G'', @fecha_fin_ppl, @codpai)  gto on GTO.codemp = emp_codigo
where plz_codcia = @codcia
and (emp_estado = ''A'' or emp_estado = ''R'')
and emp_codtpl = case
					when @codtpl in (select distinct emp_codtpl from exp.emp_empleos where emp_estado = ''A'')
					then @codtpl
					else emp_codtpl
				 end
and exists 
( (select oin_codemp
   from sal.oin_otros_ingresos
  where oin_codppl = @codppl
    and oin_codemp = emp_codigo
    and oin_ignorar_en_planilla = 0
    and oin_estado = ''Autorizado'')
  UNION
  (select ext_codemp
     from sal.ext_horas_extras
    where ext_codppl = @codppl
      and ext_codemp = emp_codigo
      and ext_ignorar_en_planilla = 0
      and ext_estado = ''Autorizado''
   )
)','emp_codigo','TodosExcluyendo',1,0);


commit transaction;

