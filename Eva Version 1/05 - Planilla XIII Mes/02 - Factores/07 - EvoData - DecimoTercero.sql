/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:10 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'a2274c4d-3258-439a-b961-048614b51277' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('a2274c4d-3258-439a-b961-048614b51277','DecimoTercero','Calcula el monto del pago del Decimo Tercero','Function DecimoTercero()

bonoSalario = 0.00
diasSalario = 0.00
anticipoXIII = 0.00
anticipoXIII_GR = 0.00

anticipoXIII = Factores("DescAnticipoXIII").Value
anticipoXIII_GR = Factores("DescAnticipoXIII_GR").Value

'' Decimo Tercero correspondiente al salario
if not PromedioSalarioXIII.EOF then
   bonoSalario = round(PromedioSalarioXIII.Fields("PROMEDIO_SALARIO").Value, 2)
   diasSalario = round(PromedioSalarioXIII.Fields("INN_DIAS_SALARIO").Value, 2)
   bonoSalario = bonoSalario / 120.00 * diasSalario
   
   ''bonoSalario = bonoSalario - anticipoXIII
   
   if bonoSalario < 0.00 then
      bonoSalario = 0.00
   end if
end if

if bonoSalario > 0 then
   agrega_ingresos_historial Agrupadores, _  
         IngresosEstaPlanilla, _
         Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
         Pla_Periodo.Fields("PPL_CODPPL").Value, _
         Factores("DecimoTercero").CodTipoIngreso, _
         bonoSalario, "PAB", diasSalario, "Dias"
end if

'' Asigna los dias trabajados asociados al Decimo Tercero
Factores("DiasTrabajados_d").Value = diasSalario

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Decimo Tercero correspondiente a los gastos de representacion
if not PromedioSalarioXIII.EOF then
   bonoGRep = round(PromedioSalarioXIII.Fields("PROMEDIO_GREP").Value, 2)
   diasGRep = round(PromedioSalarioXIII.Fields("INN_DIAS_GREP").Value, 2)
   bonoGRep = bonoGRep / 120.00 * diasGRep
   
   ''bonoGRep = bonoGRep - anticipoXIII_GR
   
   if bonoGRep < 0.00 then
      bonoGRep = 0.00
   end if
end if

if bonoGRep > 0 then
   agrega_ingresos_historial Agrupadores, _  
          IngresosEstaPlanilla, _
          Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
          Pla_Periodo.Fields("PPL_CODPPL").Value, _
          Factores("Decimo_Tercero_GRep").CodTipoIngreso, _
          bonoGRep, "PAB", diasGRep, "Dias"
end if

Factores("Decimo_Tercero_GRep").Value = bonoGRep

DecimoTercero = bonoSalario

End Function','double','pa',0);

commit transaction;
