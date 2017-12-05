/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:11 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '39db6b8c-ff50-46d2-92c3-2ae5423f5bca' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('39db6b8c-ff50-46d2-92c3-2ae5423f5bca','OtrosIngresos_d','Otros ingresos registrados para el pago de la planilla','Function OtrosIngresos_d()

o = 0.00
   
if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      vc = round(CDbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)
      
      Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   cint(Emp_OtrosIngresos.Fields("OIN_CODTIG").Value), _
                                   vc, cstr(Emp_OtrosIngresos.Fields("oin_codmon").Value), 0, "Dias" 
      o = o + vc

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos_d = o

End Function','double','pa',0);

commit transaction;
