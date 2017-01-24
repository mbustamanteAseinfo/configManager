/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:40 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'RetroGastoRep';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','RetroGastoRep','RetroGastoRep','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODIGO < 0','SELECT * FROM tmp.PIR_PAGOS_INC_RETROACT 
WHERE PIR_CODPPL = $$CODPPL$$
AND PIR_CODRSA = gen.get_valor_parametro_int(''CodigoRubroGastoRep'', ''pa'', null, null, null)','PIR_CODEMP','PIR_CODPPL','TodosExcluyendo',0,0);


commit transaction;

