/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:40 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'D08AF6E4-0DA0-48A5-A46A-7917F2C90C5D' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('D08AF6E4-0DA0-48A5-A46A-7917F2C90C5D','aju_ISR','Cálculo del impuesto sobre la renta del salario en planilla de ajustes','Function aju_ISR()

''RENTA PLANILLA DE AJUSTE

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
''if Emp_InfoSalario_Ajustes.Fields("dpl_renta").Value = 0 or Factores("ISRBaseCalculo").Value = 0 or DatosRenta.EOF or DatosRenta.BOF then
if Factores("ISRBaseCalculo_aju").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF then
   aju_ISR = valor
   Exit Function
end if

valorNeto = 0
Anual = 0
Restante = 0

AnualISR_Quincenal = 0
AnualISR_Ajuste = 0
ISR_Ajuste = 0


'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA QUINCENAL ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = Datos_Renta.Fields("rap_acumulado").Value + Datos_Renta.Fields("rap_proyectado").Value 

valorNeto = valorNeto - Datos_Renta.Fields("rap_desc_legal").Value 

TablaISR.MoveFirst
if not (TablaISR.EOF and TablaISR.BOF) then
   do until TablaISR.EOF     
      if valorNeto >= TablaISR.Fields("isr_desde").Value and valorNeto <= TablaISR.Fields("isr_hasta").Value then
          AnualISR_Quincenal = ((valorNeto - TablaISR.Fields("isr_excedente").Value ) * ( TablaISR.Fields("isr_pct").Value /100.00)) + TablaISR.Fields("isr_valor").Value
      end if
     TablaISR.MoveNext
   loop
end if




'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA DE AJUSTE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = valorNeto + Factores("ISRBaseCalculo_aju").Value
TablaISR.MoveFirst
if not (TablaISR.EOF and TablaISR.BOF) then
   do until TablaISR.EOF     
      if valorNeto >= TablaISR.Fields("isr_desde").Value and valorNeto <= TablaISR.Fields("isr_hasta").Value then
          AnualISR_Ajuste = ((valorNeto - TablaISR.Fields("isr_excedente").Value ) * ( TablaISR.Fields("isr_pct").Value /100.00)) + TablaISR.Fields("isr_valor").Value
      end if
     TablaISR.MoveNext
   loop
end if

'' Obtiene la diferencia entre el ISR de la quincena y el ISR con el Ajuste
ISR_Ajuste = AnualISR_Ajuste - AnualISR_Quincenal

if not isnull(Factores("aju_ISR").CodTipoDescuento) and ISR_Ajuste > 0 then
   Datos_Renta.Fields("rap_a_descontar").Value = ISR_Ajuste
   Datos_Renta.Fields("rap_ingreso_planilla").Value = Factores("ISRBaseCalculo_aju").Value
   
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("aju_ISR").CodTipoDescuento, _
                               ISR_Ajuste, 0, 0, _
                               "PAB", _
                               0, "Dias"
end if

aju_ISR = ISR_Ajuste

End Function','money','pa',0);

commit transaction;
