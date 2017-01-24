/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 12:24 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'Emp_HorasExtras';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codppl],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','Emp_HorasExtras','Emp_HorasExtras','select *
from sal.ext_horas_extras
JOIN sal.the_tipos_hora_extra
on the_codigo = ext_codthe
where the_codcia < 0','select *
from sal.ext_horas_extras
JOIN sal.the_tipos_hora_extra
on the_codigo = ext_codthe
where ext_estado = ''Autorizado''
and ext_ignorar_en_planilla = 0
and ext_codppl = $$CODPPL$$','ext_codemp','ext_codppl','TodosExcluyendo',0,1);


commit transaction;

