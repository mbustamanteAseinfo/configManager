/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:18 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'bd1aad4d-73f9-4a2d-87af-4f785ce10312';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('bd1aad4d-73f9-4a2d-87af-4f785ce10312','SeguroSocialPatrono_v','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono_v()
SeguroSocialPatrono_v = 0.00
End Function','double','pa',0);

commit transaction;
