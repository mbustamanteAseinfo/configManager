/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:21 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '9351d3c2-6d78-49f1-9c8f-571fbaf75a3c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9351d3c2-6d78-49f1-9c8f-571fbaf75a3c','ISR_GASTO_REP_v','Factor encargado de calcular el impuesto sobre la renta aplicado al Gasto de Representación','Function ISR_GASTO_REP_v()
''RENTA PLANILLA QUINCENAL

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario_Vacaciones.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculoGRep_v").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
  ISR_GASTO_REP_v = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00

dias = 0
dias = Factores("DiasTrabajados_v").Value

continuar = 1

ingreso_planilla = CDbl(Factores("ISR_GASTO_REP_v").Value)
Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = ingreso_planilla

if not ISR_GastoRep.EOF and not ISR_GastoRep.BOF then
  salario_quincenal = CDbl(ISR_GastoRep.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * dias / 15
    else
       valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * ingreso_planilla / salario_quincenal
       continuar = 0
    end if
  end if
  
  acumulado = CDbl(ISR_GastoRep.Fields("rag_acumulado").Value)
  proyectado = CDbl(ISR_GastoRep.Fields("rag_proyectado").Value)
  desc_legal = CDbl(ISR_GastoRep.Fields("rag_desc_legal").Value)
  isr_anual = CDbl(ISR_GastoRep.Fields("isr_anual").Value)
  
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

    TablaISR_GRep.MoveFirst
    if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
      do until TablaISR_GRep.EOF
        if ingreso_anual_planilla >= TablaISR_GRep.Fields("ISR_DESDE").Value and ingreso_anual_planilla <= TablaISR_GRep.Fields("ISR_HASTA").Value then
          isr_anual_planilla = ((ingreso_anual_planilla - TablaISR_GRep.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)) + TablaISR_GRep.Fields("ISR_VALOR").Value 
        end if
        TablaISR_GRep.MoveNext
      loop
    end if
    
    if isr_anual_planilla > isr_anual then
      valor = valor + (isr_anual_planilla - isr_anual)
    end if
  end if
end if

''if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
''  writeLog ("2. isr_anual: " & CStr(isr_anual) & ", isr_anual_planilla: " & CStr(isr_anual_planilla) & ", valor: " & CStr(valor))
''end if

if valor < 0 then
  valor = 0
end if

if valor > 0 then
   valor = round(valor * 100.00 + 0.100)/100
   Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Vacaciones.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP_v").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR_GASTO_REP_v = valor

End Function','double','pa',0);

commit transaction;
