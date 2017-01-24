/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:19 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '1be95969-50e8-4dab-8d45-b1056eede314';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1be95969-50e8-4dab-8d45-b1056eede314','SegEducativoBase_v','Base para calculo de Seguro Educativo','Function SegEducativoBase_v()

SegEducativoBase_v = Agrupadores("BaseCalculoSeguroEducativo").Value 

End Function','double','pa',0);

commit transaction;
