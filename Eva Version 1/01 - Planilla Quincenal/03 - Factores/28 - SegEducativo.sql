/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:49 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '3a659999-3b6a-4906-845c-8ac750e90c8a';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3a659999-3b6a-4906-845c-8ac750e90c8a','SegEducativo','Valor del Descuento de Seguro Educativo','Function SegEducativo()
patAnterior = 0
afectoAnterior = 0
descAnterior = 0   
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_educativo").Value = "N" then
   SegEducativo = cuota
   Exit Function
end if

if Factores("SegEducativoBase").Value >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_DESC").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_PAT").Value)
   
   afectoAnterior = cDbl(Factores("SegEducativoBase").Value)
   cuota = round(por_cuota / 100.0 * afectoAnterior, 4) - descAnterior

   if cuota < 0 then cuota = 0
 
   patronal = round(pat_cuota / 100.0 * afectoAnterior, 4) - patAnterior

   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo").CodTipoDescuento, _
                               cuota, patronal, Factores("SegEducativoBase").Value, _
                               "PAB", 0, ""
end if

Factores("SegEducativoPatronal").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro educativo
if not isnull(Factores("SegEducativoPatronal").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SegEducativoPatronal").CodTipoReserva, _
                             patronal, "PAB", 0 , ""
end if

SegEducativo = cuota

End Function','double','pa',0);

commit transaction;
