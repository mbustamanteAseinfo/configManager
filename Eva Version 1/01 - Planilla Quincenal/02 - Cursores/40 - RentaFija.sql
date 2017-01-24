/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:38 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RentaFija';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RentaFija','RentaFija','select 0 emp_codigo, 0.00 renta_anual, 0.00 renta_periodo, 0.00 sal_anual, 0.00 sal_mensual','declare @codcia int, @codppl int, @codpai varchar(2), @fecha datetime, @incluir_decimo varchar(1), @num_meses real

set @codcia = $$CODCIA$$
set @codppl = $$CODPPL$$

SELECT @codpai = cia_codpai
FROM eor.cia_companias
WHERE cia_codigo = @codcia

select @num_meses = gen.get_valor_parametro_varchar(''ISRNumeroMeses'', ''pa'', null, null, null) + 1

SELECT @fecha = ppl_fecha_fin
FROM sal.ppl_periodos_planilla
JOIN sal.tpl_tipo_planilla
ON tpl_codigo = ppl_codtpl
WHERE tpl_codcia = @codcia
AND ppl_codigo = @codppl

SELECT emp_codigo, sal.fn_get_renta_anual(plz_codcia, valor) renta_anual, sal.fn_get_renta_periodo(plz_codcia, valor) renta_periodo, valor * @num_meses sal_anual, valor sal_mensual
FROM exp.emp_empleos
JOIN eor.plz_plazas
ON plz_codigo = emp_codplz
JOIN exp.fn_get_datos_rubro_salarial(null, ''S'', @fecha, @codpai)
ON codemp = emp_codigo
WHERE plz_codcia = @codcia
AND sal.fn_get_renta_periodo(plz_codcia, valor) > 0.00
','emp_codigo','TodosExcluyendo',0,0);


commit transaction;

