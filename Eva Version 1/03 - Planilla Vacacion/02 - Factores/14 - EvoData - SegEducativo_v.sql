/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:19 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'ff82a755-fc64-421c-a8e0-8a3d722861d4';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ff82a755-fc64-421c-a8e0-8a3d722861d4','SegEducativo_v','Valor del Descuento de Seguro Educativo','Function SegEducativo_v()
patAnterior = 0
afectoAnterior = 0
descAnterior = 0   

base = 0
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_educativo").Value = "N" then
   SegEducativo_v = cuota
   Exit Function
end if

if Factores("SegEducativoBase_v").Value >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_DESC").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_PAT").Value)
   
   base = cDbl(Factores("SegEducativoBase_v").Value)
   cuota = round(por_cuota / 100.0 * base, 4)

   if cuota < 0 then cuota = 0
 
   patronal = round(pat_cuota / 100.0 * base, 4)

   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo_v").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo_v").CodTipoDescuento, _
                               cuota, patronal, base, _
                               "PAB", 0, ""
end if

Factores("SegEducativoPatronal_v").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro educativo
if not isnull(Factores("SegEducativoPatronal_v").CodTipoReserva) and patronal > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SegEducativoPatronal_v").CodTipoReserva, _
                             patronal, "PAB", 0 , ""
end if

SegEducativo_v = cuota

End Function','double','pa',0);

commit transaction;
