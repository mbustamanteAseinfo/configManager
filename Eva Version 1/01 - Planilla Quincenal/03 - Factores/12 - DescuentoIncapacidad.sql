/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:42 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '42d8a080-a9a5-47f1-8229-99bb6ed71efc';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('42d8a080-a9a5-47f1-8229-99bb6ed71efc','DescuentoIncapacidad','Descuento por Incapacidad','Function DescuentoIncapacidad()

di = 0.00
vi = 0.00

if 1 = 2 then
if not Emp_Incapacidades.EOF then
   do until Emp_Incapacidades.EOF        
      di = di + CDbl(Emp_Incapacidades.Fields("pie_horas_descontar").Value) / 8.00
      vi = vi + round(CDbl(Emp_Incapacidades.Fields("PIE_VALOR_A_DESCONTAR").Value), 2)
    Emp_Incapacidades.MoveNext
   loop
end if
end if

Factores("DiasDescuentoIncap").Value = di
DescuentoIncapacidad = vi

End Function','double','pa',0);

commit transaction;
