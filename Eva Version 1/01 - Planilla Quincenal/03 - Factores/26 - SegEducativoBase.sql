/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:48 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '48ea6d65-29b5-4da8-9dab-4f0e5592bf0d';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('48ea6d65-29b5-4da8-9dab-4f0e5592bf0d','SegEducativoBase','Base para calculo de Seguro Educativo','Function SegEducativoBase()

SegEducativoBase = Agrupadores("BaseCalculoSeguroEducativo").Value 

End Function','double','pa',0);

commit transaction;
