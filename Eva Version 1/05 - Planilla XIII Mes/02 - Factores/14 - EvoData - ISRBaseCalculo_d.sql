/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:12 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'cb666c61-9488-4263-9109-97647d4435d9' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('cb666c61-9488-4263-9109-97647d4435d9','ISRBaseCalculo_d','Base para el cálculo de renta','Function ISRBaseCalculo_d()

'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0

base = Agrupadores("IngresosRentaPTY").Value 

if base < 0 then
   base = 0
end if


'' Almacena en las reservas el devengado para renta segun el agrupador
if not isnull(Factores("ISRBaseCalculo_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("ISRBaseCalculo_d").CodTipoReserva, _
                             base,"PAB", 0, "" 
end if

ISRBaseCalculo_d = base

End Function','double','pa',0);

commit transaction;
