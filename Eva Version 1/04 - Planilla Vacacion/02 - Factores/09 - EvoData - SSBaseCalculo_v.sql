/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:18 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '9107bb74-d1e7-4dee-b8dd-eb6c5061963f' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9107bb74-d1e7-4dee-b8dd-eb6c5061963f','SSBaseCalculo_v','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo_v()

SSBaseCalculo_v = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);

commit transaction;
