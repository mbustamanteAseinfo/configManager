/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:14 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f5949487-5943-449b-ac95-907bca42829e';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f5949487-5943-449b-ac95-907bca42829e','SeguroSocial_d','Cálculo del descuento del Seguro Social','Function SeguroSocial_d()
patAnterior = 0.00
afectoAnterior = 0.00
descAnterior = 0.00
patEspecial = 0.00
   
cuota = 0.00
patronal = 0.00

'' No calcula descuentos legales para empleados temporales
''if not Factores("tieneContratoPermane").Value then
''   SeguroSocial = 0
''   exit function
''end if
   
if Factores("SSBaseCalculo_d").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_decimo").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value)
   
   '' JR (ASEINFO GT) SE COMENTO PORQUE NO SE UTILIZA POR DEFAULT
   ''pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)

   afectoAnterior = Factores("SSBaseCalculo_d").Value
      
   cuota = (por_cuota / 100) * afectoAnterior - descAnterior

   patEspecial = (pat_espec / 100) * (afectoAnterior - descAnterior)

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * afectoAnterior - patAnterior

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_d").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_d").CodTipoDescuento, _
                               cuota, patronal, Agrupadores("BaseCalculoSeguroSocial").Value, "PAB", 0, ""
end if

Factores("SeguroSocialPatrono_d").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_d").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if


Factores("SSPatronalEspecial").Value = patEspecial

'' Almacena en las reservas el aporte patronal ESPECIAL de seguro social
if not isnull(Factores("SSPatronalEspecial").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SSPatronalEspecial").CodTipoReserva, _
                             patEspecial, "PAB", 0, ""
end if

SeguroSocial_d = cuota
End Function','double','pa',0);

commit transaction;
