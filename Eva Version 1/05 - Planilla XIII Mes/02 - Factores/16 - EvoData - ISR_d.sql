/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:13 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6d957e26-744a-4259-8abf-6f60cd44b15a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6d957e26-744a-4259-8abf-6f60cd44b15a','ISR_d','Cálculo del impuesto sobre la renta','Function ISR_d()
''Si especifica que no paga renta, no ejecuta este factor
valor = 0.00
if Emp_InfoSalario.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculo_d").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF or Factores("DecimoTercero").Value <= 0 then
   ISR = valor
   Exit Function
end if

Neto = 0.00
Anual = 0.00
Restante = 0.00

Datos_Renta.Fields("RAP_INGRESO_PLANILLA").Value = Factores("ISRBaseCalculo_d").Value
Datos_Renta.Fields("RAP_PROYECTADO").Value = Datos_Renta.Fields("RAP_PROYECTADO").Value - Factores("ISRBaseCalculo_d").Value

''Neto = Factores("ISRBaseCalculo").Value * 1.50 + Datos_Renta.Fields("RAP_ACUMULADO").Value + Datos_Renta.Fields("RAP_PROYECTADO").Value 
Neto = Factores("ISRBaseCalculo_d").Value + Datos_Renta.Fields("RAP_ACUMULADO").Value + Datos_Renta.Fields("RAP_PROYECTADO").Value 
Neto = Neto - Datos_Renta.Fields("RAP_DESC_LEGAL").Value 

TablaISR.MoveFirst

 if not (TablaISR.EOF and TablaISR.BOF) then
    do until TablaISR.EOF
       if Neto >= TablaISR.Fields("ISR_DESDE").Value and Neto <= TablaISR.Fields("ISR_HASTA").Value then
           Anual = ((Neto - TablaISR.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR.Fields("ISR_PCT").Value /100.00)) + TablaISR.Fields("ISR_VALOR").Value 
           Restante = Anual - Datos_Renta.Fields("RAP_RETENIDO").Value 
           if Datos_Renta.Fields("RAP_PERIODOS_RESTANTES").Value = 0 then
              valor = Restante
           else
              valor = round((Restante/ (Datos_Renta.Fields("RAP_PERIODOS_RESTANTES").Value)),2) * 2.00 / 3.00
              valor = round(valor*100.00 + 0.100)/100
           end if

           if valor > 0 then
              if not RentaAdelantoXIII.EOF then
                 valor = valor - RentaAdelantoXIII.Fields("VALOR").Value
                 if valor < 0 then
                    valor = 0
                 end if
              end if
           end if

           ''if valor > Agrupadores("XIIIMes").Value then
           ''   valor = 0
           ''end if

           if not isnull(Factores("ISR_d").CodTipoDescuento) and valor > 0 then
              Datos_Renta.Fields("RAP_A_DESCONTAR").Value = valor
              
              agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_d").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, "Dias"
            end if
       end if
       TablaISR.MoveNext
    loop
 end if

ISR_d = valor
End Function','double','pa',0);

commit transaction;
