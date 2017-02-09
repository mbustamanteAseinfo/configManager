/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:11 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'b9bd0f33-6d74-438e-a000-b3c615c1ef90';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('b9bd0f33-6d74-438e-a000-b3c615c1ef90','DescExcesoXIII_GR','Descuento por Exceso XIII pendiente por aplicar del gasto de representación','Function DescExcesoXIII_GR()

DescExcesoXIII_GR = 0.00

End Function','double','pa',0);

commit transaction;
