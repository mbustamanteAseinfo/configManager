/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:40 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '213D36BC-452A-444D-9814-F826136D52B4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('213D36BC-452A-444D-9814-F826136D52B4','aju_OtrosDescuentos','Procesa otros descuentos asociados a la planilla de ajustes','Function aju_OtrosDescuentos()

liquido = Factores("aju_SalarioBruto").Value - _
          Factores("SeguroSocial_aju").Value - _
          Factores("SegEducativo_aju").Value - _
          Factores("aju_ISR").Value - _
          Factores("aju_ISR_GR").Value


sum = 0
valor = 0 

if Emp_OtrosDescuentos.RecordCount > 0 then
   Emp_OtrosDescuentos.MoveFirst
   do until Emp_OtrosDescuentos.EOF
      valor = round(Emp_OtrosDescuentos.Fields("ods_valor_a_descontar").Value, 2)
      if valor > liquido then
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 0
         
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 1
         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ods_codtdc").Value, _
                                     valor, _
                                     0, 0, _
                                     Emp_OtrosDescuentos.Fields("ods_codmon").Value, _
                                     0, "Dias"
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if
aju_OtrosDescuentos = sum

End Function','money','pa',0);

commit transaction;
