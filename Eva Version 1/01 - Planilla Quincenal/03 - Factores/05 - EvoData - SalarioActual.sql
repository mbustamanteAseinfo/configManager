/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:40 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'c1e6999c-9b4d-4a8d-825b-ef938d1891d1';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c1e6999c-9b4d-4a8d-825b-ef938d1891d1','SalarioActual','Salario Actual','Function SalarioActual()

salq = 0

'' - CALCULA SALARIO ACTUAL
if isnull( cdbl(Emp_InfoSalario.Fields("EMP_SALARIO").Value) ) then
  salq = 0
else
  salq = (cdbl(Emp_InfoSalario.Fields("EMP_SALARIO").Value))
end if
   
SalarioActual = salq

End Function','double','pa',0);

commit transaction;
