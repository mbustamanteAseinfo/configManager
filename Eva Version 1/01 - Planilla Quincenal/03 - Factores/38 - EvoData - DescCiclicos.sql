/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:51 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '4b75e4c1-472f-4ad5-a3bf-3ed14d5b084b';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('4b75e4c1-472f-4ad5-a3bf-3ed14d5b084b','DescCiclicos','Detalle de Descuentos Ciclicos','Function DescCiclicos()
liquido = Factores("IngresoIncapacidad").Value + Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value - _
          Factores("OtrosDescuentos").Value
   
dc = 0.00
vc = 0.00
aplicada = False

IF not (CuotasDescuentosCiclicos.EOF and CuotasDescuentosCiclicos.bof) then

Do Until CuotasDescuentosCiclicos.EOF

        vc = Round(CDbl(CuotasDescuentosCiclicos.Fields("cdc_valor_cobrado").Value), 2)

       '' Si el valor de cuota es cero y el porcentaje es mayor que cero, debo calcular la cuota en el momento
       if vc = 0 and CDbl(CuotasDescuentosCiclicos.Fields("dcc_porcentaje").Value) > 0 then
          for i = 1 to Agrupadores.Count
              if Agrupadores(i).Codigo = cint(CuotasDescuentosCiclicos.Fields("dcc_codagr").Value) then
                 vc = round(Agrupadores(i).Value * cdbl(CuotasDescuentosCiclicos.Fields("dcc_porcentaje").Value) / 100, 2)
                 CuotasDescuentosCiclicos.Fields("cdc_valor_cobrado").Value = vc
                 exit for
              end if
              next
        end if

        If (liquido - vc) > 0 Then
            aplicada = True
            liquido = liquido - vc
            dc = dc + vc
            CuotasDescuentosCiclicos.Fields("cdc_fecha_descuento").Value = Pla_Periodo.Fields("PPL_FECHA_PAGO").Value
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 1

            agrega_descuentos_historial Agrupadores, _
                                        DescuentosEstaPlanilla, _
                                        Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                        Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                        CuotasDescuentosCiclicos.Fields("dcc_codtdc").Value, _
                                        vc, 0, 0, "PAB", 0, ""
        Else
            aplicada = False
            ''CuotasDescuentosCiclicos.Fields("CDC_VENCIMIENTO").Value = Null
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 0            
        End If

   CuotasDescuentosCiclicos.MoveNext
 Loop
else
   dc=0.00
end if

DescCiclicos = dc
End Function','double','pa',0);

commit transaction;
