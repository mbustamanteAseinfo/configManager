/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:13 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '15148a7e-87ac-4ab3-8288-087f367fe82c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('15148a7e-87ac-4ab3-8288-087f367fe82c','ISR_GASTO_REP_d','Cálculo del impuesto sobre la renta sobre el gasto de representación','Function ISR_GASTO_REP_d()
''RENTA PLANILLA DECIMO TERCERO

ingreso_planilla = 0.00
ingreso_planilla = CDbl(Factores("ISRBaseCalculoGRep_d").Value)

if not Datos_Renta_Gastos_Rep.EOF and not Datos_Renta_Gastos_Rep.BOF then
   Datos_Renta_Gastos_Rep.Fields("RAG_INGRESO_PLANILLA").Value = ingreso_planilla
end if

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta_gr").Value = "N" or Factores("ISRBaseCalculoGRep_d").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
  ISR_GASTO_REP_d = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00
decimo_regular = 0.00

continuar = 1

if not ISR_GastoRep.EOF and not ISR_GastoRep.BOF then
  decimo_regular = round(CDbl(ISR_GastoRep.Fields("salario_quincenal").Value) * 2 / 3, 2)
  if ingreso_planilla = decimo_regular then
    valor = round(CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * 2 / 3, 2)
    continuar = 0
  else
    if ingreso_planilla > decimo_regular then
      valor = round(CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * 2 / 3, 2)
    else
       valor = round(CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * 2 / 3, 2) * ingreso_planilla / decimo_regular
       continuar = 0
    end if
  end if
  
  proyectado = CDbl(ISR_GastoRep.Fields("rag_proyectado").Value)
  Datos_Renta_Gastos_Rep.Fields("RAG_PROYECTADO").Value = proyectado - decimo_regular 
  
  acumulado = CDbl(ISR_GastoRep.Fields("rag_acumulado").Value)
  proyectado = proyectado - decimo_regular
  desc_legal = CDbl(ISR_GastoRep.Fields("rag_desc_legal").Value)
  isr_anual = CDbl(ISR_GastoRep.Fields("isr_anual").Value)
  
  ingreso_anual_planilla = acumulado + proyectado + ingreso_planilla - desc_legal
  
end if

if valor < 0 then
  valor = 0
end if

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

if valor < 0 then
  valor = 0
end if

if valor > 0 then
   valor = round(valor * 100.00 + 0.100)/100
   Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP_d").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR_GASTO_REP_d = valor

End Function','double','pa',0);

commit transaction;
