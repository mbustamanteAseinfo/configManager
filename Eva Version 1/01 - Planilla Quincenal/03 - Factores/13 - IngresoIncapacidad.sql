/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:42 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '72d579d4-c281-4569-b4e9-f61ed36bdae3';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('72d579d4-c281-4569-b4e9-f61ed36bdae3','IngresoIncapacidad','Obtiene el monto a pagar en concepto de incapacidad','Function IngresoIncapacidad()

valor = 0
dias = 0
diasPagados = 0
S = 0
horas = 0

''if not DiasPagadosIncapacidad.EOF then
''   diasPagados = CDbl(DiasPagadosIncapacidad.Fields("DIAS_PAGADOS").Value)
''end if

while not Emp_Incapacidades.EOF
   valor = valor + CDbl(Emp_Incapacidades.Fields("PIE_VALOR_A_PAGAR").Value)
   if CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value) > 0 then
      dias = dias + CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value) / 8
      horas = horas + CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value)
   else
      dias = dias + CDbl(Emp_Incapacidades.Fields("PIE_DIAS").Value)
      horas = horas + CDbl(Emp_Incapacidades.Fields("PIE_DIAS").Value) * 8 
   end if

   Emp_Incapacidades.MoveNext
wend

dias = round(dias, 2)

if dias = 15 then
   valor = CDbl(Emp_InfoSalario.Fields("emp_salario").Value) / 2.00
end if

''if (diasPagados + dias) > 36 then
''   valor = 0
''end if

if valor > 0 then
   S = CDbl(Factores("SueldoQuincenal").Value)
   if diasPagados > 0 then
      if (dias + diasPagados) >= 36 then
         S = 0
      else
         S = S - valor
      end if
   else
      S = S - valor
   end if
   Factores("SueldoQuincenal").Value = S
end if

if not isnull(Factores("SueldoQuincenal").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SueldoQuincenal").CodTipoIngreso, _
                             valor * -1.00, "PAB", horas * -1, "Horas"
end if


if not isnull(Factores("IngresoIncapacidad").CodTipoIngreso) and valor > 0 then
   Factores("DiasIncapacidad").Value = dias

   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("IngresoIncapacidad").CodTipoIngreso, _
                             valor, "PAB", horas, "Horas"
end if

IngresoIncapacidad = valor

End Function','double','pa',0);

commit transaction;
