/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:12 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '597292e5-30a0-4669-bacc-a15bf419e6f8' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('597292e5-30a0-4669-bacc-a15bf419e6f8','SSBaseCalculo_d','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo_d()

SSBaseCalculo_d = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);

commit transaction;
