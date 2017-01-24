/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:10 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '005636ba-b9c4-4f2a-b41b-bca88c984435';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('005636ba-b9c4-4f2a-b41b-bca88c984435','DescAnticipoXIII','Aplica el descuento por el anticipo del XIII que haya sido pagado en el período de la planilla','Function DescAnticipoXIII()

anticipoXIII = 0.00
anticipoXIII_GR = 0.00

if not AnticipoXIII_Pagado.EOF then
   anticipoXIII = AnticipoXIII_Pagado.Fields("ADELANTO_XIII").Value
   anticipoXIII_GR = AnticipoXIII_Pagado.Fields("ADELANTO_XIII_GR").Value
   
   Factores("DescAnticipoXIII_GR").Value = anticipoXIII_GR
end if

DescAnticipoXIII = anticipoXIII

End Function','double','pa',0);

commit transaction;
