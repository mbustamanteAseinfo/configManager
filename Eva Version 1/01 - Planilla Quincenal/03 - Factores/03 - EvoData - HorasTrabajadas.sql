/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:40 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6e65914f-76c3-4adc-ba53-804823b17246';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6e65914f-76c3-4adc-ba53-804823b17246','HorasTrabajadas','Horas trabajadas en el periodo','Function HorasTrabajadas

HorasTrabajadas = 0.00

End Function','double','pa',0);

commit transaction;
