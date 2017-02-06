/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:38 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '0C62DA23-33DF-457D-A7E2-49C0DE23F86F' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0C62DA23-33DF-457D-A7E2-49C0DE23F86F','SeguroSocial_aju','Cálculo del descuento del Seguro Social','Function SeguroSocial_aju()

cuota = 0
patronal = 0
   

if Factores("SSBaseCalculo_aju").Value >= 0.01 then
      por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
      pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)

   
   cuota = (por_cuota / 100) * Factores("SSBaseCalculo_aju").Value
   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * Factores("SSBaseCalculo_aju").Value
   if patronal < 0 then patronal = 0
end if
patronal = round(patronal + 0.00000001, 2)
cuota = round(cuota + 0.00000001, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_aju").CodTipoDescuento) and cuota > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_aju").CodTipoDescuento, _
                               cuota, patronal, Factores("SSBaseCalculo_aju").Value, _
                               "PAB", _
                               0, _
                               "Dias"
end if

SeguroSocial_aju = cuota

End Function
','double','pa',0);

commit transaction;
