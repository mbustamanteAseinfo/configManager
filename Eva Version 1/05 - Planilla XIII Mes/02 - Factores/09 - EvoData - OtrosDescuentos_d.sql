/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:11 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'd9bab822-bee7-4029-98c7-eb2b96516c83' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d9bab822-bee7-4029-98c7-eb2b96516c83','OtrosDescuentos_d','Otros descuentos de planilla decimo tercero','Function OtrosDescuentos_d()
liquido = Factores("DecimoTercero").Value + _
          Factores("Decimo_Tercero_GRep").Value + _
          Factores("OtrosIngresos_d").Value
   
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
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, ""
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if
   
OtrosDescuentos_d = sum
End Function','double','pa',0);

commit transaction;
