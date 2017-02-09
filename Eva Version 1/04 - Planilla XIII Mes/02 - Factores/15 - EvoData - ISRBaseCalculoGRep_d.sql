/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:12 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '9db7d3f0-52a2-447e-b64d-f4d4fd2c3c13';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9db7d3f0-52a2-447e-b64d-f4d4fd2c3c13','ISRBaseCalculoGRep_d','Base cálculo del impuesto sobre la renta para el caso del gasto de representación','Function ISRBaseCalculoGRep_d()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0

base = Agrupadores("IngresosRentaGRepPTY").Value

if base < 0 then
   base = 0
end if


'' Almacena en las reservas el devengado para renta segun el agrupador
if not isnull(Factores("ISRBaseCalculoGRep_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("ISRBaseCalculoGRep_d").CodTipoReserva, _
                             base, "PAB", 0, ""
end if

ISRBaseCalculoGRep_d = base

End Function','double','pa',0);

commit transaction;
