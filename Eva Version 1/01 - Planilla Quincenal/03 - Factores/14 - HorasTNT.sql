/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:42 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '1050797b-a815-4051-a694-2221f8690858';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1050797b-a815-4051-a694-2221f8690858','HorasTNT','Cantidad de horas no trabajadas por el empleado','Function HorasTNT()

HorasTNT = 0

End Function','double','pa',0);

commit transaction;
