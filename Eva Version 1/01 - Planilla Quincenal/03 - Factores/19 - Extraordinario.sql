/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:45 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '723cfb33-aea2-434d-a573-56e93fb236b6';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('723cfb33-aea2-434d-a573-56e93fb236b6','Extraordinario','Valor total de horas extras','Function Extraordinario()
vc = 0
ex = 0
hor = 0


   if not Emp_HorasExtras.EOF then
      do until Emp_HorasExtras.EOF
         vc = round(CDbl(Emp_HorasExtras.Fields("ext_valor_a_pagar").Value), 2)
         hor= round(CDbl(Emp_HorasExtras.Fields("ext_num_horas").Value) + CDbl(Emp_HorasExtras.Fields("ext_num_mins").Value) / 60.00, 2)
         
         agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   Emp_HorasExtras.Fields("the_codtig").Value, _
                                   vc, "PAB", hor, "Horas"
         Emp_HorasExtras.Fields("ext_aplicado_planilla").Value = 1
         ex = ex + vc
         Emp_HorasExtras.MoveNext
      loop
   end if


Extraordinario = ex
End Function','double','pa',0);

commit transaction;
