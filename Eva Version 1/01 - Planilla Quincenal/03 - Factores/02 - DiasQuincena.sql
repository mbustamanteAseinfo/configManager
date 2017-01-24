/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:39 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'dd8c90cd-3e65-431a-b301-65b19c4c1f35';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('dd8c90cd-3e65-431a-b301-65b19c4c1f35','DiasQuincena','Cantidad de días del período para el empleado','Function DiasQuincena()

DiasQuincena = 15.00

End Function','double','pa',0);

commit transaction;
