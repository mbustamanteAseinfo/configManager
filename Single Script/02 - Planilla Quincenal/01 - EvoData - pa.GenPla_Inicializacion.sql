IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.GenPla_Inicializacion')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[GenPla_INC_GeneraPeriodosIncapacidad]    Script Date: 16-01-2017 9:45:27 AM ******/
DROP PROCEDURE [pa].[GenPla_Inicializacion]
GO

CREATE PROCEDURE [pa].[GenPla_Inicializacion]
	@sessionId uniqueidentifier = null,
    @codppl int,
    @userName varchar(100) = null
as

set @userName = isnull(@userName, system_user)

set nocount on
set dateformat dmy

begin transaction
	
declare @codcia int, @codtpl int, @codtpl_quincenal int

SELECT @codcia = tpl_codcia, @codtpl = tpl_codigo
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla
ON tpl_codigo = ppl_codtpl
WHERE ppl_codigo = @codppl

-- OBTIENE EL TIPO DE PLANILLA RESPECTIVO A LA EMPRESA
select @codtpl_quincenal = isnull(gen.get_valor_parametro_int('CodigoPlanillaQuincenal', null, null, @codcia, null), 1)

-- INGRESOS
delete from sal.inn_ingresos
where inn_codppl = @codppl
--and (sal.empleado_en_gen_planilla(@sessionId, inn_codemp) = 1
--     or inn_codemp in (select emp_codigo from exp.emp_empleos
--	                    where emp_estado = 'R' )) /* or emp_codtpl <> @codtpl*/

-- DESCUENTOS
delete from sal.dss_descuentos
where dss_codppl = @codppl
--and (sal.empleado_en_gen_planilla(@sessionId, dss_codemp) = 1
--     or dss_codemp in (select emp_codigo from exp.emp_empleos
--	                    where emp_estado = 'R' ))

-- RESERVAS
delete from sal.res_reservas
where res_codppl = @codppl
--and (sal.empleado_en_gen_planilla(@sessionId, res_codemp) = 1
--     or res_codemp in (select emp_codigo from exp.emp_empleos
--	                    where emp_estado = 'R' ))

-- HISTORICO DE PLANILLAS CALCULADAS
delete 
from sal.hpa_hist_periodos_planilla
where hpa_codppl = @codppl
--and (sal.empleado_en_gen_planilla(@sessionId, hpa_codemp) = 1
--     or hpa_codemp in (select emp_codigo from exp.emp_empleos
--	                    where emp_estado = 'R' ))

---- Marca Incapacidades como aplicadas en planilla
--UPDATE acc.pie_periodos_incapacidad
--   set pie_aplicado_planilla = 0
--WHERE pie_planilla_autorizada = 0
--AND (pie_valor_a_pagar > 0 or PIE_VALOR_A_DESCONTAR > 0)
--AND pie_codppl = @codppl
--AND exists (select null 
--			  from acc.ixe_incapacidades
--			  JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
--			  JOIN acc.rin_riesgos_incapacidades on rin_codigo= ixe_codrin
--			where ixe_codigo = pie_codixe
--			  AND rin_utiliza_fondo = 1
--			)

-- Traslada a la planilla actual los ingresos y descuentos no aplicados en la ultima planilla
exec pa.proc_traslada_no_aplicados @codppl

-- Genera las cuotas de los descuentos cíclicos
exec pa.GenPla_DCC_GeneraCuotas @sessionId, @codppl, @userName 

-- Genera las cuotas de los ingresos cíclicos
exec pa.GenPla_IGC_GeneraCuotas @sessionId, @codppl, @userName 

-- Genera los montos por tiempos no trabajados
exec pa.GenPla_TNT_Revalua @sessionId, @codppl, @userName 

-- Genera los montos de las horas extras
exec pa.GenPla_HorasExtras_Revalua @sessionId, @codppl, @userName 
	
-- Genera periodos de incapacidad
exec pa.GenPla_INC_GeneraPeriodosIncapacidad @sessionId, @codppl, @userName 
	
--Genera la Renta para el Salario
exec pa.GenPla_GeneraRenta  @sessionId, @codppl, @userName 
	
--Genera la Renta para el Gasto de Representación
exec pa.GenPla_GeneraRenta_GastoRep @sessionId, @codppl, @userName 

-- Genera los montos de los ingresos eventuales cuyo monto no es fijo
exec pa.GenPla_IngresosEventuales_Revalua @sessionId, @codppl, @userName 

-- Genera los montos por retroactivo de los incrementos
if @codtpl = @codtpl_quincenal -- Planilla Quincenal
begin
	exec pa.GenPla_Calcula_Retroactivos @sessionId, @codppl, @userName 
	exec pa.GenPla_Calcula_Retroactivos_GastoRep @sessionId, @codppl, @userName 
end
	
--select * from sal.tnn_tiempos_no_trabajados join sal.tnt_tipos_tiempo_no_trabajado on tnt_codigo = tnn_codtnt where tnt_goce_sueldo = 0 and tnn_codppl = 1014
--select * from sal.ods_otros_descuentos where ods_codppl = 1014

insert into sal.ods_otros_descuentos
	(ods_lote_masivo, ods_codemp, ods_codtdc, ods_fecha, ods_num_horas, ods_salario_hora, ods_valor_a_descontar, ods_codmon, ods_codppl, ods_aplicado_planilla, ods_planilla_autorizada, ods_ignorar_en_planilla, ods_codemp_solicita, ods_estado, ods_fecha_cambio_estado, ods_estado_workflow, ods_ingresado_portal, ods_usuario_grabacion, ods_fecha_grabacion)
select tnn_codigo as lote_masivo, tnn_codemp, tnt_codtdc, tnn_fecha_del, tnn_num_horas, 0.00 salario_hora, tnn_valor_a_descontar, tnn_codmon, tnn_codppl, 0 aplicado_planilla, 0 planilla_autorizada, tnn_ignorar_en_planilla, null codemp_solicita, tnn_estado, getdate() fecha_cambio_estado, tnn_estado estado_workflow, 0 ingresado_portal, tnn_usuario_grabacion, getdate()
from sal.tnn_tiempos_no_trabajados 
join sal.tnt_tipos_tiempo_no_trabajado 
on tnt_codigo = tnn_codtnt 
where tnt_goce_sueldo = 0 
and tnn_codppl = @codppl

commit transaction
return

