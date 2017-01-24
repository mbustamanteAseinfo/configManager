/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:41 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '8d60069a-0beb-41ea-977f-600fc6e41574';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8d60069a-0beb-41ea-977f-600fc6e41574','DiasDescuentoIncap','Dias Descuento Incapacidad','Function DiasDescuentoIncap()

DiasDescuentoIncap = 0

End Function','double','pa',0);

commit transaction;
