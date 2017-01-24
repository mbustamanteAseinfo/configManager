/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:19 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '8b29cd99-cc00-4177-8cde-694527f86554';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8b29cd99-cc00-4177-8cde-694527f86554','SegEducativoPatronal_v','Parte Patronal del Seguro Educativo','Function SegEducativoPatronal_v()

SegEducativoPatronal_v = 0.00

End Function','double','pa',0);

commit transaction;
