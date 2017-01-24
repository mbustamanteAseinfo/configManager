/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:19 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6a5ea415-9181-47a9-969c-12a5cf9169a4';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6a5ea415-9181-47a9-969c-12a5cf9169a4','ISRBaseCalculoGRep_v','Base para calculo de renta para gastos de representacion','Function ISRBaseCalculoGRep_v()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0.00

base = Agrupadores("IngresosRentaGRepPTY").Value

if base < 0.00 then
   base = 0.00
end if

ISRBaseCalculoGRep_v = base
End Function','double','pa',0);

commit transaction;
