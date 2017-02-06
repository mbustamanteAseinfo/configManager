/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:49 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'fd68b0c7-2e7c-4ad5-89e4-fab4f61c8f0b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('fd68b0c7-2e7c-4ad5-89e4-fab4f61c8f0b','ISRBaseCalculoGRep','Base para calculo de renta para gastos de representacion','Function ISRBaseCalculoGRep()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0

base = Agrupadores("IngresosRentaGRepPTY").Value 

if base < 0 then
   base = 0
end if

ISRBaseCalculoGRep = base
End Function','double','pa',0);

commit transaction;
