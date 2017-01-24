/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:12 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6dc55c1a-e329-4401-b168-4f9bd221584a';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6dc55c1a-e329-4401-b168-4f9bd221584a','SegSocialGR_BaseCalc','Seguro Social de Gastos de Representación','Function SegSocialGR_BaseCalc()

SegSocialGR_BaseCalc = Agrupadores("XIIIMesGR").Value ''Factores("Decimo_Tercero_GRep").Value

End Function','double','pa',0);

commit transaction;
