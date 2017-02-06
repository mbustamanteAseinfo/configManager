/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:49 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '0b6f201f-7443-4aa8-a466-e670027ad6b4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0b6f201f-7443-4aa8-a466-e670027ad6b4','ISRBaseCalculo','Base para calculo de renta','Function ISRBaseCalculo()
'' Almacena en las reservas el devengado para renta segun el agrupador
base = 0

base = Agrupadores("IngresosRentaPTY").Value

if base < 0 then
   base = 0
end if

ISRBaseCalculo = base
End Function','double','pa',0);

commit transaction;
