/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:40 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6bbc67e0-c6cd-490c-9257-2d496a48735d';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6bbc67e0-c6cd-490c-9257-2d496a48735d','SueldoQuincenal','Salario de la Quincena','Function SueldoQuincenal()

S = 0
Dias = Factores("DiasTrabajados").Value
horas = Factores("HorasTrabajadas").Value 

if not PagoProporcionalIncremento.EOF then
   S = cdbl(PagoProporcionalIncremento.Fields("SALARIO_ACTUAL").Value) + cdbl(PagoProporcionalIncremento.Fields("SALARIO_PREVIO").Value)
else
   if not SalarioNuevoIngreso.EOF then
      S = CDbl(SalarioNuevoIngreso.Fields("salario_proporcional").Value )
      Dias = CDbl(SalarioNuevoIngreso.Fields("dias").Value)
   else
      if not DiasPSGS.EOF then
         S = CDbl(DiasPSGS.Fields("HORAS").Value) * CDbl(Emp_InfoSalario.Fields("emp_salario_hora").Value)
      else
         S = (cdbl(Emp_InfoSalario.Fields("emp_salario").Value)/30) * Factores("DiasTrabajados").Value
         
         ''if not SalarioImpar.EOF and not SalarioImpar.BOF then
         ''   S = CDbl(SalarioImpar.Fields("pago").Value)
         ''end if
         
      end if
      
      if not DiasPendientesPagoNuevoIngreso.EOF then
         if CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value) > 0 then
            Dias = Dias + CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value)
            Factores("DiasTrabajados").Value = Factores("DiasTrabajados").Value + Dias
            S = round(S + cdbl(DiasPendientesPagoNuevoIngreso.Fields("salario_proporcional").Value),2)
         end if
      end if
   end if
end if

if not isnull(Factores("SueldoQuincenal").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SueldoQuincenal").CodTipoIngreso, _
                             S, "PAB", horas, "Horas"
end if

SueldoQuincenal = S

End Function','double','pa',0);

commit transaction;
