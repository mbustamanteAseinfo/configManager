/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:18 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '4e81387b-73f1-455e-8577-0ad288ea090d';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('4e81387b-73f1-455e-8577-0ad288ea090d','SeguroSocial_v','Cálculo del descuento del Seguro Social','Function SeguroSocial_v()

patAnterior = 0
afectoAnterior = 0
descAnterior = 0
patEspecial = 0

base = 0
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_social").Value = "N" then
   SeguroSocial = cuota
   Exit Function
end if
   
if Factores("SSBaseCalculo_v").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)
   
   base = CDbl(Factores("SSBaseCalculo_v").Value)

   cuota = (por_cuota / 100) * base

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * base

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_v").CodTipoDescuento) and cuota > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_v").CodTipoDescuento, _
                               cuota, patronal, base, _
                               "PAB", 0, ""
end if

Factores("SeguroSocialPatrono_v").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_v").CodTipoReserva) and patronal then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_v").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if

SeguroSocial_v = cuota

End Function','double','pa',0);

commit transaction;
