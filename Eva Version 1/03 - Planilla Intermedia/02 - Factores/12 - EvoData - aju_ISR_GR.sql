/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:40 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '5CBE3135-6C4A-46AC-8927-FCACE58FAD04' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5CBE3135-6C4A-46AC-8927-FCACE58FAD04','aju_ISR_GR','Cálculo del impuesto sobre la renta del salario en planilla quincenal, vacaciones, decimo tecero','Function aju_ISR_GR ()

''RENTA PLANILLA DE AJUSTE

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
''if Emp_InfoSalario_Ajustes.Fields("dpl_renta").Value = 0 or Factores("ISRBaseCalculoGRep").Value = 0 or DatosRenta_GastoRep.EOF or DatosRenta_GastoRep.BOF then
if Factores("ISRBaseCalculoGRep_aju").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
   aju_ISR_GR = valor
   Exit Function
end if

valorNeto = 0
Anual = 0
Restante = 0

AnualISR_Quincenal = 0
AnualISR_Ajuste = 0
ISR_Ajuste = 0

'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA QUINCENAL ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = Datos_Renta_Gastos_Rep.Fields("rag_acumulado").Value + Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value 
valorNeto = valorNeto - Datos_Renta_Gastos_Rep.Fields("rag_desc_legal").Value 
TablaISR_GRep.MoveFirst
if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
   do until TablaISR_GRep.EOF
      if valorNeto >= TablaISR_GRep.Fields("isr_desde").Value and valorNeto <= TablaISR_GRep.Fields("isr_hasta").Value then
          AnualISR_Quincenal = ((valorNeto - TablaISR_GRep.Fields("isr_excedente").Value ) * ( TablaISR_GRep.Fields("isr_pct").Value /100.00)) + TablaISR_GRep.Fields("isr_valor").Value 
      end if
     TablaISR_GRep.MoveNext
   loop
end if

'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA DE AJUSTE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = valorNeto + Factores("ISRBaseCalculoGRep_aju").Value
TablaISR_GRep.MoveFirst
if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
   do until TablaISR_GRep.EOF
      if valorNeto >= TablaISR_GRep.Fields("isr_desde").Value and valorNeto <= TablaISR_GRep.Fields("isr_hasta").Value then
          AnualISR_Ajuste = ((valorNeto - TablaISR_GRep.Fields("isr_excedente").Value ) * ( TablaISR_GRep.Fields("isr_pct").Value /100.00)) + TablaISR_GRep.Fields("isr_valor").Value 
      end if
      TablaISR_GRep.MoveNext
   loop
end if

'' Obtiene la diferencia entre el ISR de la quincena y el ISR con el Ajuste
ISR_Ajuste = AnualISR_Ajuste - AnualISR_Quincenal

if not isnull(Factores("aju_ISR_GR").CodTipoDescuento) and ISR_Ajuste > 0 then
   Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = ISR_Ajuste
   Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = Factores("ISRBaseCalculoGRep_aju").Value
     
    agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("aju_ISR_GR").CodTipoDescuento, _
                               ISR_Ajuste, 0, 0, _
                               "PAB", _
                               0, "Dias"
end if

aju_ISR_GR = ISR_Ajuste

End Function','money','pa',0);

commit transaction;
