/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:21 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'ca0fc64b-7958-4c29-8e66-3b7862059945' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ca0fc64b-7958-4c29-8e66-3b7862059945','DescCiclicos_v','Detalle de Descuentos Cíclicos para Vacaciones','Function DescCiclicos_v()

liquido = Factores("SalarioBruto_v").Value - _
          Factores("SeguroSocial_v").Value - _
          Factores("SegEducativo_v").Value - _
          Factores("ISR_v").Value - _
          Factores("ISR_GASTO_REP_v").Value - _
          Factores("OtrosDescuentos_v").Value
   
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
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 0            
        End If

   CuotasDescuentosCiclicos.MoveNext
 Loop
else
   dc=0.00
end if

DescCiclicos_v = dc
End Function','double','pa',0);

commit transaction;
