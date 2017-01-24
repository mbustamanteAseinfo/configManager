/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:13 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'da82728a-120a-499b-9398-81d7ea990811';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('da82728a-120a-499b-9398-81d7ea990811','SSPatronalEspecial','Aporte patronal especial del seguro social','Function SSPatronalEspecial()

SSPatronalEspecial = 0

End Function','double','pa',0);

commit transaction;
