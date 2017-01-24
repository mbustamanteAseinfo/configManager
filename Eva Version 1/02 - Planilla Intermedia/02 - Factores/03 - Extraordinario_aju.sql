/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:36 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'B023400F-182F-4905-848E-1529A8266869';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('B023400F-182F-4905-848E-1529A8266869','Extraordinario_aju','Horas extras','Function Extraordinario_aju()
valor = 0
total = 0
horas = 0

if not Emp_HorasExtras.EOF then
   do until Emp_HorasExtras.EOF
      valor = round(cdbl(Emp_HorasExtras.Fields("ext_valor_a_pagar").Value), 2)
      horas = cdbl(Emp_HorasExtras.Fields("ext_num_horas").Value) 
      agrega_ingresos_historial Agrupadores, _
                                IngresosEstaPlanilla, _
                                Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                Emp_HorasExtras.Fields("the_codtig").Value, _
                                valor, _
                                Emp_HorasExtras.Fields("ext_codmon").Value, _
                                horas, _
                                "Horas"
      total = total + valor
      Emp_HorasExtras.MoveNext
   loop
end if

Extraordinario_aju = total
End Function
','double','pa',0);

commit transaction;
