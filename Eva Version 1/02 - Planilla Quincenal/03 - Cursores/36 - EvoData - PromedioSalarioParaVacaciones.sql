/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:37 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PromedioSalarioParaVacaciones';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PromedioSalarioParaVacaciones','PromedioSalarioParaVacaciones','SELECT INN_CODEMP, INN_VALOR AS PROMEDIO, inn_tiempo AS INN_DIAS FROM sal.inn_ingresos WHERE inn_codigo < 1','declare @ult_fecha_pago datetime,
		@agr_ingresos int,
		@codcia int,
		@codtpl_quincenal int,
		@codtpl_vacacion int

select @codcia = $$CODCIA$$

select @codtpl_quincenal = isnull(gen.get_valor_parametro_int(''PA_CodigoPlanillaQuincenal'', null, null, @codcia, null), 1)
select @codtpl_vacacion = isnull(gen.get_valor_parametro_int(''PA_CodigoPlanillaVacacion'', null, null, @codcia, null), 1)

-- Agrupador que contiene los ingresos utilizados para calcular el promedio
select @agr_ingresos = agr_codigo from sal.agr_agrupadores where agr_codpai = ''pa'' and agr_abreviatura = ''IngresosVacacion'' -- Agrupador ingresos calculo de vacacion

-- Fecha de pago de la ultima planilla autorizada
select @ult_fecha_pago = max(ppl_fecha_pago)
from sal.ppl_periodos_planilla
where PPL_ESTADO = ''Autorizado''
AND PPL_CODTPL = @codtpl_quincenal
and PPL_FECHA_PAGO <= (SELECT MIN(V.PPL_FECHA_PAGO) FROM sal.ppl_periodos_planilla V WHERE V.PPL_CODTPL = @codtpl_vacacion AND V.PPL_ESTADO = ''Generado'')

if day(@ult_fecha_pago) > 15
begin 
   set @ult_fecha_pago = gen.fn_last_day(@ult_fecha_pago)
end
else
begin
   set @ult_fecha_pago = gen.fn_last_day(@ult_fecha_pago)
   set @ult_fecha_pago = dateadd(day,-16,@ult_fecha_pago)
end

select INN_CODEMP, round(SUM(isnull(INN_VALOR,0.00))/11,2) as PROMEDIO,SUM(ISNULL(inn_tiempo,0)) as INN_DIAS
from sal.inn_ingresos
join sal.ppl_periodos_planilla on ppl_codigo = inn_codppl
join exp.emp_empleos on EMP_CODIGO = INN_CODEMP
join eor.plz_plazas on plz_codigo = emp_codplz
where plz_codcia = @codcia
and PPL_FECHA_PAGO <= @ult_fecha_pago
and PPL_FECHA_PAGO >= dateadd(mm, -11, @ult_fecha_pago)
and PPL_ESTADO = ''Autorizado''
and inn_codtig in (select iag_codtig from sal.iag_ingresos_agrupador
						join sal.tig_tipos_ingreso on tig_codigo = iag_codtig
						where iag_codagr = @agr_ingresos
						and tig_codcia = @CODCIA)
group by INN_CODEMP
order by INN_CODEMP
','inn_codemp','TodosExcluyendo',0,0);


commit transaction;

