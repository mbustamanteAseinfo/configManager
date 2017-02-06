/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:18 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '113a5429-05e5-4492-b046-a8efccf4866b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('113a5429-05e5-4492-b046-a8efccf4866b','OtrosIngresos_v','Otros Ingresos','Function OtrosIngresos_v()

o = 0.00
horas = 0.00

if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      vc = round(CDbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)
      horas = CDbl(Emp_OtrosIngresos.Fields("oin_num_horas").Value)
      
      Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   cint(Emp_OtrosIngresos.Fields("OIN_CODTIG").Value), _
                                   vc, cstr(Emp_OtrosIngresos.Fields("oin_codmon").Value), horas, "Horas"
      o = o + vc

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos_v = o

End Function','double','pa',0);

commit transaction;
