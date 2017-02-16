/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:35 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'ParametrosCuotaISSS';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','ParametrosCuotaISSS','ParametrosCuotaISSS','SELECT 0.00 pge_isss_por_desc, 
	   0.00 pge_isss_por_desc_pat, 
	   0.00 pge_isss_por_desc_decimo, 
	   0.00 pge_isss_por_desc_pat_decimo,
	   0.00 pge_riesgo_prof_por_desc_pat,
	   0.00 pge_profuturo_pa','declare @codcia int

set @codcia = $$CODCIA$$

declare @codpai varchar(2)

select @codpai = cia_codpai
from eor.cia_companias
where cia_codigo = @codcia

SELECT gen.get_valor_parametro_float(''CuotaEmpleadoSeguroSocial'', @codpai, null, null, null) pge_isss_por_desc,
       gen.get_valor_parametro_float(''CuotaPatronoSeguroSocial'', @codpai, null, null, null) pge_isss_por_desc_pat,
       gen.get_valor_parametro_float(''CuotaEmpleadoSeguroSocialXIII'', @codpai, null, null, null) pge_isss_por_desc_decimo,
       gen.get_valor_parametro_float(''CuotaPatronoSeguroSocialXIII'', @codpai, null, null, null) pge_isss_por_desc_pat_decimo,
       gen.get_valor_parametro_float(''CuotaPatronoRiesgoProfesional'', @codpai, null, null, null) pge_riesgo_prof_por_desc_pat,
       gen.get_valor_parametro_float(''CuotaPrimaAntiguedad'', @codpai, null, null, null) pge_profuturo_pa
       ','TodosExcluyendo',0,0);


commit transaction;

