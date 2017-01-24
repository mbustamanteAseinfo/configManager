/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:48 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f62949ca-2c72-48d0-a55e-b055b0901064';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f62949ca-2c72-48d0-a55e-b055b0901064','SeguroSocial','Cálculo del descuento del Seguro Social','Function SeguroSocial()

patAnterior = 0
afectoAnterior = 0
descAnterior = 0
patEspecial = 0
   
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_social").Value = "N" then
   SeguroSocial = cuota
   Exit Function
end if

'' No calcula descuentos legales para empleados temporales
''if not Factores("tieneContratoPermane").Value then
''   SeguroSocial = 0
''   exit function
''end if
   
if Factores("SSBaseCalculo").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)
''   pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)

   afectoAnterior = Factores("SSBaseCalculo").Value
      
   cuota = (por_cuota / 100) * afectoAnterior - descAnterior

''   patEspecial = (pat_espec / 100) * (afectoAnterior - descAnterior)

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * afectoAnterior - patAnterior

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial").CodTipoDescuento, _
                               cuota, patronal, Agrupadores("BaseCalculoSeguroSocial").Value, _
                               "PAB", 0, ""
end if

Factores("SeguroSocialPatrono").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if

SeguroSocial = cuota

End Function','double','pa',0);

commit transaction;
