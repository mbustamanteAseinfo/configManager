/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:38 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'D0EE2447-A9ED-40B9-AD16-B2FA76F70C5D';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('D0EE2447-A9ED-40B9-AD16-B2FA76F70C5D','SegEducativoBase_aju','Base para cálculo de Seguro Educativo','Function SegEducativoBase_aju()
SegEducativoBase_aju = Agrupadores("BaseCalculoSeguroEducativo").Value
End Function
','double','pa',0);

commit transaction;
