/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:48 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '9c60e57a-b6c2-43cf-89b6-61cb8b122bf9' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9c60e57a-b6c2-43cf-89b6-61cb8b122bf9','SeguroSocialPatrono','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono()

SeguroSocialPatrono = 0

End Function','double','pa',0);

commit transaction;
