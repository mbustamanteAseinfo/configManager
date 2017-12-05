/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:10 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f44f064e-c4e1-48b0-bd59-2da1848a6d30' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f44f064e-c4e1-48b0-bd59-2da1848a6d30','DescAnticipoXIII_GR','Aplica el descuento por el anticipo del XIII de GR que haya sido pagado en el período de la planilla','Function DescAnticipoXIII_GR()

DescAnticipoXIII_GR = 0.00

End Function','double','pa',0);

commit transaction;
