/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:49 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'c5dc36f7-0685-4a27-a9a5-824f8aeaa292' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c5dc36f7-0685-4a27-a9a5-824f8aeaa292','DevolucionDescRenta','Devolucion por Descuento de Renta','Function DevolucionDescRenta()

DevolucionDescRenta = 0

End Function','double','pa',0);

commit transaction;
