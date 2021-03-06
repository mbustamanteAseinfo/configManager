
/****** Object:  StoredProcedure [pa].[GenPla_TNT_Revalua]    Script Date: 16-01-2017 9:30:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[GenPla_TNT_Revalua] (
	@sessionId uniqueidentifier = null,
    	@codppl int,
    	@userName varchar(100) = null
) 
as

-- declaracion de variables locales 
declare @codcia int,
	@codpai varchar(2),
        @fecha_ppl datetime

-- Obtiene la fecha de finalizacion y la frecuencia del periodo de planilla que va a utilizar 
select @fecha_ppl = ppl_fecha_fin,
       @codcia = tpl_codcia,
       @codpai = cia_codpai 
  from sal.ppl_periodos_planilla (nolock)
  join sal.tpl_tipo_planilla (nolock)
  on tpl_codigo = ppl_codtpl
  join eor.cia_companias (nolock)
  on cia_codigo = tpl_codcia 
 where ppl_codigo = @codppl


update sal.tnn_tiempos_no_trabajados
   set tnn_valor_a_descontar = (case when tnt_porcentaje_descuento  = 100 then
									convert(numeric(12,4), ( coalesce(tnn_num_dias, 0) * 8.0000 + coalesce(tnn_num_horas, 0.0000) + isnull(tnn_num_mins,0)/60.00) * valor_hora)
								else 
									0.0000
								end),
       tnn_valor_a_pagar = (case when tnt_porcentaje_descuento = 100 then
								0.0000
							else
								CASE when tnt_codtig IS NOT NULL
									 then convert(numeric(12,4), ( coalesce(tnn_num_dias, 0) * 8.0000 + coalesce(tnn_num_horas, 0.0000) + isnull(tnn_num_mins,0)/60.00 ) * valor_hora)
								else 0.0000
								end
							END),
       tnn_salario_hora = valor_hora,
       tnn_salario_diario = valor_hora * 8.0000
       --tnn_valor = round(tnn_valor_real * (IsNull(tnn_valor_hr, 0) / 100), 2)
from exp.fn_get_datos_rubro_salarial(null, 'S', @fecha_ppl, @codpai)
join sal.tnt_tipos_tiempo_no_trabajado
on tnt_codcia = codcia
where codemp = tnn_codemp
and tnt_codigo = tnn_codtnt
and tnn_codppl = @codppl
and tnn_estado = 'Autorizado'
and tnn_ignorar_en_planilla = 0
and sal.empleado_en_gen_planilla(@sessionId, tnn_codemp) = 1

return
