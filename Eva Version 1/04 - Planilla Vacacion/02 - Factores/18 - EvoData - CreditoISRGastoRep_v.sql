/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:20 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '5756f168-f8b2-4638-8075-ca7149f5e78c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5756f168-f8b2-4638-8075-ca7149f5e78c','CreditoISRGastoRep_v','Valor del Descuento por Gasto de Representacion','Function CreditoISRGastoRep_v()
CreditoISRGastoRep_v = 0.00
End Function','double','pa',0);

commit transaction;
