/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:41 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'eefe89cd-86f4-4847-8c8c-f84a3dcd5ed4';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('eefe89cd-86f4-4847-8c8c-f84a3dcd5ed4','DiasIncapacidad','Dias de Incapacidad','Function DiasIncapacidad()

DiasIncapacidad = 0

End Function','double','pa',0);

commit transaction;
