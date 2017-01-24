/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:40 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ReservasEstaPlanilla';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ReservasEstaPlanilla','Tabla que almacena las reservas de esta planilla','select * 
from tmp.res_reservas
where res_codppl  = -1','select * 
from tmp.res_reservas
where res_codppl = $$CODPPL$$','res_codemp','res_codppl','TodosExcluyendo',0,1);


commit transaction;

