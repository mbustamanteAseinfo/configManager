/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:49 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '59c6d4c3-e1d5-46d0-9641-ea7994f7e124' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('59c6d4c3-e1d5-46d0-9641-ea7994f7e124','SegEducativoPatronal','Parte Patronal del Seguro Educativo','Function SegEducativoPatronal()

SegEducativoPatronal = 0

End Function','double','pa',0);

commit transaction;
