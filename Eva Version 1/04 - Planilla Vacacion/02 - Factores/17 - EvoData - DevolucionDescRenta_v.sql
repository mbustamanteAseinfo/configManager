/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:20 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f461c66c-e739-45a6-8da9-8d78294d0301' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f461c66c-e739-45a6-8da9-8d78294d0301','DevolucionDescRenta_v','Devolucion por Descuento de Renta','Function DevolucionDescRenta_v()
DevolucionDescRenta_v = 0.00
End Function','double','pa',0);

commit transaction;
