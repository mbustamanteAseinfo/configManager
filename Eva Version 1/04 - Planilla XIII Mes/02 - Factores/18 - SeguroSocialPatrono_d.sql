/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:13 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '3e4ea582-1b4b-4baa-83a4-d7949d452642';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3e4ea582-1b4b-4baa-83a4-d7949d452642','SeguroSocialPatrono_d','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono_d()

SeguroSocialPatrono_d = 0

End Function','double','pa',0);

commit transaction;
