/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:38 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '1168CFE1-DEB7-4635-AC83-98B929C65E25';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1168CFE1-DEB7-4635-AC83-98B929C65E25','SSBaseCalculo_aju','Base para cálculo de Seguro Social','Function SSBaseCalculo_aju()
   SSBaseCalculo_aju = Agrupadores("BaseCalculoSeguroSocial").Value
End Function','double','pa',0);

commit transaction;
