/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:46 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f0017293-0f88-4516-b35c-4964d32e292b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f0017293-0f88-4516-b35c-4964d32e292b','OtrosDescAplicaLegal','Procesa Otros Descuentos asociados al periodo de pago afectos a descuentos legales','Function OtrosDescAplicaLegal()
liquido = Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value
   
sum = 0
valor = 0 
horas = 0.00

if Emp_OtrosDescuentos_AplicaLegal.RecordCount > 0 then
   Emp_OtrosDescuentos_AplicaLegal.MoveFirst
   do until Emp_OtrosDescuentos_AplicaLegal.EOF
      valor = round(Emp_OtrosDescuentos_AplicaLegal.Fields("ods_valor_a_descontar").Value, 2)
      horas = CDbl(Emp_OtrosDescuentos_AplicaLegal.Fields("ods_num_horas").Value)
   
      if valor > liquido then
         Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_APLICADO_PLANILLA").Value = 0
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_APLICADO_PLANILLA").Value = 1
         
         if horas > 0 then
         	agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", horas, "Horas"
         else
         	agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, "Dias"
         end if
      end if
      Emp_OtrosDescuentos_AplicaLegal.MoveNext
   loop
end if

if sum > 0 then
   Factores("SalarioBruto").Value = Factores("SalarioBruto").Value - sum
end if

OtrosDescAplicaLegal = sum
End Function','double','pa',0);

commit transaction;
