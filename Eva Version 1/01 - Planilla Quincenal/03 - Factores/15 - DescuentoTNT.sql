/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:42 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'ff7a9453-e976-4dd6-a080-4d8c06ac814d';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ff7a9453-e976-4dd6-a080-4d8c06ac814d','DescuentoTNT','Descuento por Tiempo no Trabajado','Function DescuentoTNT()
dnt = 0.00
sum = 0.00

if not Emp_TmpNoTrabajado.EOF and 1 = 2 then
   do until Emp_TmpNoTrabajado.EOF
      if not isnull(Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value) and not isnull(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value) and Emp_TmpNoTrabajado.Fields("tnn_codppl").Value = Pla_Periodo.Fields("PPL_CODPPL").Value then
         if Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value > 0 and not isnull(Emp_TmpNoTrabajado.Fields("tnt_codtig").Value) then
            agrega_ingresos_historial Agrupadores, _
			                 IngresosEstaPlanilla, _
			                 Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
			                 Pla_Periodo.Fields("PPL_CODPPL").Value, _
			                 Emp_TmpNoTrabajado.Fields("tnt_codtig").Value, _
			                 cdbl(Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value), _
			                 "PAB", _
			                 ((cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value) + CDbl(Emp_TmpNoTrabajado.Fields("tnn_num_mins").Value) / 60.00) / 8) + cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value), _
							   "Horas"						                 
            
            Emp_TmpNoTrabajado.Fields("tnn_aplicado_planilla").Value = 1
            Factores("DiasTrabajados").Value = Factores("DiasTrabajados").Value - ((Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value / 8) + Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value)
            Factores("SueldoQuincenal").Value = Factores("SueldoQuincenal").Value - Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value
         end if
         
         if Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value > 0 and not isnull(Emp_TmpNoTrabajado.Fields("tnt_codtdc").Value) then
            sum = sum + Round(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value, 2) 
            dnt = dnt + round(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value, 2) * 8 + round(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value, 2)
            
            agrega_descuentos_historial Agrupadores, _
			            DescuentosEstaPlanilla, _
			            Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
			            Pla_Periodo.Fields("PPL_CODPPL").Value, _
			            Emp_TmpNoTrabajado.Fields("tnt_codtdc").Value, _
			            round(cdbl(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value), 2), 0, 0, _
			            "PAB", _
			            ((cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value) + CDbl(Emp_TmpNoTrabajado.Fields("tnn_num_mins").Value) / 60.00) ) + cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value) * 8, _
			            "Horas"
			Emp_TmpNoTrabajado.Fields("tnn_aplicado_planilla").Value = 1       
                
        end if
      end if
      
      Emp_TmpNoTrabajado.MoveNext
   loop
end if

Factores("HorasTNT").Value = dnt
DescuentoTNT = sum

End Function','double','pa',0);

commit transaction;
