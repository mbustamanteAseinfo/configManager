/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:50 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'a22c44d2-0eba-4a41-9784-90484819f221' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('a22c44d2-0eba-4a41-9784-90484819f221','CreditoISRGastoRep','Valor del Descuento por Gasto de Representacion','Function CreditoISRGastoRep()

CreditoISRGastoRep = 0

End Function','double','pa',0);

commit transaction;
