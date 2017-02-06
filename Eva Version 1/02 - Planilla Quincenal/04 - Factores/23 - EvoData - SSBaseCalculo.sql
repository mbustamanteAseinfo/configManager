/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:48 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f9dc52a5-30ea-4957-9f17-54954d0a4a7e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f9dc52a5-30ea-4957-9f17-54954d0a4a7e','SSBaseCalculo','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo()

SSBaseCalculo = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);

commit transaction;
