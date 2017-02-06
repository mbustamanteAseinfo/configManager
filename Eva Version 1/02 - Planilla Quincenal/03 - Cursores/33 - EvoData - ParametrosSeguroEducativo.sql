/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:36 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ParametrosSeguroEducativo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ParametrosSeguroEducativo','ParametrosSeguroEducativo','SELECT 0.00 pge_seg_educativo_por_desc, 0.00 pge_seg_educativo_por_pat','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

SELECT gen.get_valor_parametro_float(''PA_CuotaEmpleadoSeguroEducativo'', @codpai, null, null, null) pge_seg_educativo_por_desc,
       gen.get_valor_parametro_float(''PA_CuotaPatronoSeguroEducativo'', @codpai, null, null, null) pge_seg_educativo_por_pat
','TodosExcluyendo',0,0);


commit transaction;

