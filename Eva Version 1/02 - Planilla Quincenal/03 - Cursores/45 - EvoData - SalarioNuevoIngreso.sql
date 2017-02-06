/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:41 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'SalarioNuevoIngreso';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','SalarioNuevoIngreso','SalarioNuevoIngreso','select cia_codigo emp_codcia, cia_codigo emp_codigo, 0 dias, 0.00 horas, 0.0000 salario_proporcional
from eor.cia_companias
where cia_codigo = 0','declare @codcia int, @codtpl int, @codppl int

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

exec pa.proc_cur_SalarioNuevoIngreso @codcia, @codtpl, @codppl','emp_codigo','emp_codcia','TodosExcluyendo',0,0);


commit transaction;

