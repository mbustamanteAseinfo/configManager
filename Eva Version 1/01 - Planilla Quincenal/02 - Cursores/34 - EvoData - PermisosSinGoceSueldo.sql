/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 1:36 PM */

begin transaction

delete from [sal].[fcu_formulacion_cursores] where [fcu_codpai] = 'pa' and [fcu_nombre] = 'PermisosSinGoceSueldo';


insert into [sal].[fcu_formulacion_cursores] ([fcu_codpai],[fcu_proceso],[fcu_nombre],[fcu_descripcion],[fcu_select_edit],[fcu_select_run],[fcu_field_codemp],[fcu_field_codcia],[fcu_modo_asociacion_tpl],[fcu_loop_calculo],[fcu_updatable]) values ('pa','Planilla','PermisosSinGoceSueldo','PermisosSinGoceSueldo','SELECT tnt_codcia TNN_CODCIA, TNN_CODEMP, TNN_CODTNT, TNN_FECHA_DEL, TNN_FECHA_AL
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia < 0','declare @codcia int, @codtpl int, @codppl int, @fecha_ini datetime, @fecha_fin datetime

set @codcia = $$CODCIA$$
set @codtpl = $$CODTPL$$
set @codppl = $$CODPPL$$

SELECT @fecha_ini = PPL_FECHA_INI, @fecha_fin = PPL_FECHA_FIN
FROM sal.ppl_periodos_planilla
WHERE PPL_CODTPL = @codtpl
AND PPL_CODIGO = @codppl

SELECT tnt_codcia TNN_CODCIA, TNN_CODEMP, TNN_CODTNT, TNN_FECHA_DEL, TNN_FECHA_AL
FROM sal.tnn_tiempos_no_trabajados
join sal.tnt_tipos_tiempo_no_trabajado on tnn_codtnt = tnt_codigo
WHERE tnt_codcia = @codcia
AND TNN_ESTADO = ''A''
AND tnt_goce_sueldo = 0 /* TIPOS DE TIEMPOS NO TRABAJADOS SIN GOCE DE SUELDO */
AND TNN_FECHA_DEL <= @fecha_ini
AND TNN_FECHA_AL >= @fecha_fin
UNION
SELECT txi_codcia IXE_CODCIA, IXE_CODEMP,  0, IXE_INICIO, IXE_FINAL
FROM acc.ixe_incapacidades
JOIN acc.txi_tipos_incapacidad ON txi_codigo = ixe_codtxi
JOIN acc.rin_riesgos_incapacidades ON rin_codigo = ixe_codrin
WHERE txi_codcia = @codcia
AND rin_utiliza_fondo = 0 
AND (
   (IXE_INICIO <= @fecha_ini AND IXE_FINAL >= @fecha_fin) OR
   (IXE_INICIO <= @fecha_ini AND (IXE_FINAL >= @fecha_ini AND IXE_FINAL <= @fecha_fin)) OR
   ((IXE_INICIO >= @fecha_ini AND IXE_INICIO <= @fecha_fin) AND (IXE_FINAL >= @fecha_fin))
)/* Maternidad, Riesgo Profesional, Pension por Enfermedad*/','tnn_codemp','tnt_codcia','TodosExcluyendo',0,0);


commit transaction;

