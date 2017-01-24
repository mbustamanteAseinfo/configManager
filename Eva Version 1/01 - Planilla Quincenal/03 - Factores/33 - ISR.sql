/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:50 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'd1465930-c563-44d2-98a7-b27f9461b79e';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d1465930-c563-44d2-98a7-b27f9461b79e','ISR','Descuento de Impuesto sobre la Renta','Function ISR()
''RENTA PLANILLA QUINCENAL
ingreso_planilla = CDbl(Factores("ISRBaseCalculo").Value)
Datos_Renta.Fields("RAP_INGRESO_PLANILLA").Value = ingreso_planilla

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculo").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF then
  ISR = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00

continuar = 1

if not ISR_Salario.EOF and not ISR_Salario.BOF then
  salario_quincenal = CDbl(ISR_Salario.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value)
    else
       valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value) * ingreso_planilla / salario_quincenal
       continuar = 0
    end if
  end if
  
  acumulado = CDbl(ISR_Salario.Fields("rap_acumulado").Value)
  proyectado = CDbl(ISR_Salario.Fields("rap_proyectado").Value)
  desc_legal = CDbl(ISR_Salario.Fields("rap_desc_legal").Value)
  isr_anual = CDbl(ISR_Salario.Fields("isr_anual").Value)
  
  ingreso_anual_planilla = acumulado + proyectado + ingreso_planilla - desc_legal
end if

if valor < 0 then
  valor = 0
end if

''if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
''  writeLog ("1. valor: " & CStr(valor) & ", continuar: " & CStr(continuar) & ", ingreso_anual_planilla: " & CStr(ingreso_anual_planilla))
''end if

if continuar = 1 then
  if ingreso_anual_planilla > 0 then

    TablaISR.MoveFirst
    if not (TablaISR.EOF and TablaISR.BOF) then
      do until TablaISR.EOF
        if ingreso_anual_planilla >= TablaISR.Fields("ISR_DESDE").Value and ingreso_anual_planilla <= TablaISR.Fields("ISR_HASTA").Value then
          isr_anual_planilla = ((ingreso_anual_planilla - TablaISR.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR.Fields("ISR_PCT").Value /100.00)) + TablaISR.Fields("ISR_VALOR").Value 
        end if
        TablaISR.MoveNext
      loop
    end if
    
    if isr_anual_planilla > isr_anual then
      valor = valor + (isr_anual_planilla - isr_anual)
    end if
  end if
end if

if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
  writeLog ("2. isr_anual: " & CStr(isr_anual) & ", isr_anual_planilla: " & CStr(isr_anual_planilla) & ", valor: " & CStr(valor))
end if

if valor < 0 then
  valor = 0
end if

if valor > 0 then
   valor = round(valor * 100.00 + 0.100)/100
   Datos_Renta.Fields("rap_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR = valor

End Function','double','pa',0);

commit transaction;
