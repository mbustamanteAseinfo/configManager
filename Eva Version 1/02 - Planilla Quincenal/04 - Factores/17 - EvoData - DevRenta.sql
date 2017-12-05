/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:44 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '77ebc94e-3505-46e0-9f32-b6c4475d1e6b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('77ebc94e-3505-46e0-9f32-b6c4475d1e6b','DevRenta','Devolucion de Renta','Function DevRenta()

DevRenta = o

End Function','double','pa',0);

commit transaction;
