/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:40 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '5170a1c5-de74-4d09-b6dd-e324c59613ac' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5170a1c5-de74-4d09-b6dd-e324c59613ac','GastoRepresentacion','Valor de Gastos de Representacion','Function GastoRepresentacion()

S = 0
Dias = Factores("DiasTrabajados").Value
if Dias > 15 then
   Dias = 15
end if
horas = Factores("HorasTrabajadas").Value

''if not PagoProporcionalIncremento.EOF then
''   S = cdbl(PagoProporcionalIncremento.Fields("SALARIO_ACTUAL").Value) + cdbl(PagoProporcionalIncremento.Fields("SALARIO_PREVIO").Value)
''else
   if not GastoRepNuevoIngreso.EOF then
      S = CDbl(GastoRepNuevoIngreso.Fields("salario_proporcional").Value )
      Dias = CDbl(GastoRepNuevoIngreso.Fields("dias").Value)
   else
      S = (cdbl(Emp_InfoSalario.Fields("emp_gastos_representacion").Value)/30) * Dias
      
      ''if not GastoRepImpar.EOF and not GastoRepImpar.BOF then
      ''   S = CDbl(GastoRepImpar.Fields("pago").Value)
      ''end if
         
      if not DiasPendientesPagoNuevoIngreso.EOF then
         if CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value) > 0 then
            Dias = Dias + CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value)
            S = round(S + cdbl(DiasPendientesPagoNuevoIngreso.Fields("gasto_rep_proporcional").Value),2)
         end if
      end if
   end if
''end if

if not isnull(Factores("GastoRepresentacion").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("GastoRepresentacion").CodTipoIngreso, _
                             S, "PAB", horas, "Horas"
end if

GastoRepresentacion = S

End Function','double','pa',0);

commit transaction;
