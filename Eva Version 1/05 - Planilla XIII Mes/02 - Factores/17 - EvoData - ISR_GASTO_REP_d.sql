/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:13 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '15148a7e-87ac-4ab3-8288-087f367fe82c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('15148a7e-87ac-4ab3-8288-087f367fe82c','ISR_GASTO_REP_d','Cálculo del impuesto sobre la renta sobre el gasto de representación','Function ISR_GASTO_REP_d()
valor = 0.00
''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta_gr").Value = "N" or Factores("ISRBaseCalculoGRep_d").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
   ISR_GASTO_REP_d = valor
   Exit Function
end if

Neto = 0
Anual = 0
Restante = 0

Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = Factores("ISRBaseCalculoGRep_d").Value
''Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value = Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value - Agrupadores("IngresosRentaGRepPTY").Value

''Neto = Datos_Renta_Gastos_Rep.Fields("RAP_ACUMULADO").Value + Datos_Renta_Gastos_Rep.Fields("RAP_PROYECTADO").Value 
Neto = Factores("ISRBaseCalculoGRep_d").Value = 0 + Datos_Renta_Gastos_Rep.Fields("rag_acumulado").Value + Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value

Neto = Neto - Datos_Renta_Gastos_Rep.Fields("rag_desc_legal").Value 

TablaISR_GRep.MoveFirst

 if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
    do until TablaISR_GRep.EOF

       if Neto >= TablaISR_GRep.Fields("ISR_DESDE").Value and Neto <= TablaISR_GRep.Fields("ISR_HASTA").Value then
           if TablaISR_GRep.Fields("ISR_VALOR").Value <> 0 then
              Anual = ((Neto - TablaISR_GRep.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)) + TablaISR_GRep.Fields("ISR_VALOR").Value 
              Restante = Anual - Datos_Renta_Gastos_Rep.Fields("rag_retenido").Value 
              if Datos_Renta_Gastos_Rep.Fields("rag_periodos_restantes").Value = 0 then
                 valor = Restante
              else
                 valor = (Restante/ (Datos_Renta_Gastos_Rep.Fields("rag_periodos_restantes").Value)) * 2.00 / 3.00
              end if
           else
              valor = Factores("ISRBaseCalculoGRep_d").Value * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)
              valor = round(valor, 2)
           end if
           
           if valor > 0 then
              if not RentaAdelantoXIIIGR.EOF then
                 valor = valor - RentaAdelantoXIIIGR.Fields("VALOR").Value
                 if valor < 0 then
                    valor = 0
                 end if
              end if
           end if

           if not isnull(Factores("ISR_GASTO_REP_d").CodTipoDescuento) and valor > 0 then
              Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = valor
              
              agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP_d").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
            end if
       end if

    TablaISR_GRep.MoveNext
    loop
 end if

ISR_GASTO_REP_d = valor
End Function','double','pa',0);

commit transaction;
