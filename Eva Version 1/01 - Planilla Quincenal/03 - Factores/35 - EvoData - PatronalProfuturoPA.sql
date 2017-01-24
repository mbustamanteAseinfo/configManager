/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:50 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '05b6bda7-ac4c-44f2-a9df-12e73406d28e';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('05b6bda7-ac4c-44f2-a9df-12e73406d28e','PatronalProfuturoPA','Calculo de aporte patronal AFP PA','Function PatronalProfuturoPA

PatronalProfuturoPA = 0 

End Function','double','pa',0);

commit transaction;
