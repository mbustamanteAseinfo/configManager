/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:08 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'c2da53a4-827e-4fbf-bb42-6c075bd9e2bc';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c2da53a4-827e-4fbf-bb42-6c075bd9e2bc','DiasQuincena_d','Cantidad de días del período para el empleado','Function DiasQuincena_d()

DiasQuincena_d = 120

End Function','double','pa',0);

commit transaction;
