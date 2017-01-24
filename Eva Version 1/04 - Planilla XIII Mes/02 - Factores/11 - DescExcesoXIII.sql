/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:11 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f7b1bd19-2697-4d79-a121-d1b43fffe130';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f7b1bd19-2697-4d79-a121-d1b43fffe130','DescExcesoXIII','Descuento por Exceso XIII pendiente por aplicar','Function DescExcesoXIII()
Decimo = 0.00
DecimoGr = 0.00

Exceso = 0.00
ExcesoGr = 0.00

''Decimo = CDbl(Factores("DecimoTercero").Value)
Decimo = Agrupadores("XIIIMes").Value
if Decimo > 0 then
   if not ExcesoXIII.EOF then
      Exceso = CDbl(ExcesoXIII.Fields("EXCESO").Value)
      if Exceso >= Decimo then
         Exceso = Decimo
      end if
   end if
end if

if Exceso > 0 then
   '' Inserta el registro en la tabla de descuentos
   if not isnull(Factores("DescExcesoXIII").CodTipoDescuento) then
      agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescExcesoXIII").CodTipoDescuento, _
                               Exceso, 0, 0, "PAB", 0, "Dias"
   end if
end if

''DecimoGr = CDbl(Factores("Decimo_Tercero_GRep").Value)
DecimoGr = Agrupadores("XIIIMesGR").Value
if DecimoGr > 0 then
   if not ExcesoXIII_GR.EOF then
      ExcesoGr = CDbl(ExcesoXIII_GR.Fields("EXCESO").Value)
      if ExcesoGr >= DecimoGr then
         ExcesoGr = DecimoGr
      end if
   end if
end if

if ExcesoGr > 0 then
   '' Inserta el registro en la tabla de descuentos
   if not isnull(Factores("DescExcesoXIII_GR").CodTipoDescuento) then
      agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescExcesoXIII_GR").CodTipoDescuento, _
                               ExcesoGr, 0, 0, "PAB", 0, "Dias"
   end if
end if

DescExcesoXIII = Exceso

End Function','double','pa',0);

commit transaction;
