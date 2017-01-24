/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:50 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '36a139d3-3575-4154-8865-3f00cf7689ac';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('36a139d3-3575-4154-8865-3f00cf7689ac','PatronalProfuturoIDM','Cuota patronal profuturo de Indemnizacion','Function PatronalProfuturoIDM()

PatronalProfuturoIDM = 0 

End Function','double','pa',0);

commit transaction;
