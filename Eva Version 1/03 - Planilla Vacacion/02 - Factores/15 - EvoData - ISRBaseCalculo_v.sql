/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:19 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '48c4597a-bc15-414d-b312-80ede54a79e9';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('48c4597a-bc15-414d-b312-80ede54a79e9','ISRBaseCalculo_v','Base para calculo de renta','Function ISRBaseCalculo_v()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0.00

base = Agrupadores("IngresosRentaPTY").Value

if base < 0 then
   base = 0.00
end if

ISRBaseCalculo_v = base
End Function','double','pa',0);

commit transaction;
