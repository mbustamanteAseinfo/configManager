/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:21 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'e0dc35bb-f005-454d-826b-33048b6ddb2f';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('e0dc35bb-f005-454d-826b-33048b6ddb2f','OtrosDescuentos_v','Procesa Otros Descuentos asociados al periodo de pago','Function OtrosDescuentos_v()
liquido = Factores("SalarioBruto_v").Value - _
          Factores("SeguroSocial_v").Value - _
          Factores("SegEducativo_v").Value - _
          Factores("ISR_v").Value - _
          Factores("ISR_GASTO_REP_v").Value
   
sum = 0
valor = 0 
horas = 0.00

if Emp_OtrosDescuentos.RecordCount > 0 then
   Emp_OtrosDescuentos.MoveFirst
   do until Emp_OtrosDescuentos.EOF
      valor = round(Emp_OtrosDescuentos.Fields("ods_valor_a_descontar").Value, 2)
      horas = CDbl(Emp_OtrosDescuentos.Fields("ods_num_horas").Value)
   
      if valor > liquido then
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 0
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 1
         
         if horas > 0 then
	         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", horas, "Horas"
         else
	         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, ""
         end if
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if

OtrosDescuentos_v = sum
End Function','double','pa',0);

commit transaction;
