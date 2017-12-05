/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:10 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'b7ecbdb0-a784-44fc-b2df-d78a39ac538a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('b7ecbdb0-a784-44fc-b2df-d78a39ac538a','Decimo_Tercero_GRep','Factor que Calcula el Valor del Decimo Tercer Mes del Gasto de Representacion.','Function Decimo_Tercero_GRep()

Decimo_Tercero_GRep = 0.00

End Function','double','pa',0);

commit transaction;
