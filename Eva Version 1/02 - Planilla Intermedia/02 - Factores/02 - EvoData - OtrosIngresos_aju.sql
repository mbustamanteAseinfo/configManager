/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:36 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '7D1AF3D1-70A8-4168-8C97-E62AEFBA44B2';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('7D1AF3D1-70A8-4168-8C97-E62AEFBA44B2','OtrosIngresos_aju','Otros ingresos','Function OtrosIngresos_aju()
valorTotal = 0

if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      valor = round(cdbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)

	  Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   Emp_OtrosIngresos.Fields("oin_codtig").Value, _
                                   valor, _
                                   Emp_OtrosIngresos.Fields("oin_codmon").Value, _
                                   0, _
                                   "Dias"
      valorTotal = valorTotal + valor

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos_aju = valorTotal
End Function','double','pa',0);

commit transaction;
