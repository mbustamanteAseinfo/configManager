/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:15 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'ea4d0a07-d399-45b0-bfb7-f07ef5f8c8be' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ea4d0a07-d399-45b0-bfb7-f07ef5f8c8be','DiasQuincena_v','Cantidad de días del período para el empleado','Function DiasQuincena_v()

DiasQuincena_v = 15

End Function','double','pa',0);

commit transaction;
