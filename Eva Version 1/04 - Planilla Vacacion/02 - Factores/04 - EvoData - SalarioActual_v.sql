/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:17 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '610ea80b-7768-4853-94ce-31ce32abb8ee' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('610ea80b-7768-4853-94ce-31ce32abb8ee','SalarioActual_v','Salario Actual','Function SalarioActual_v()

SalarioActual_v = 0.00

End Function','double','pa',0);

commit transaction;
