/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:41 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '0894c89e-3154-40a8-adef-5fac024b0201';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0894c89e-3154-40a8-adef-5fac024b0201','RetroactivoGastoRep','Retroactivo del gasto de representacion','Function RetroactivoGastoRep()

valor = 0
dias = 0

if not (RetroGastoRep.EOF and RetroGastoRep.BOF) then
   valor = CDbl(RetroGastoRep.Fields("PIR_MONTO_RETROACTIVO").Value)
   dias = CDbl(RetroGastoRep.Fields("PIR_DIAS_RETROACTIVO").Value)
   
   if not isnull(Factores("RetroactivoGastoRep").CodTipoIngreso) and valor > 0 then
      agrega_ingresos_historial Agrupadores, _
                                     IngresosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Factores("RetroactivoGastoRep").CodTipoIngreso, _
                                     valor, "PAB", dias, "Dias"
   end if
end if

RetroactivoGastoRep = valor

End Function','double','pa',0);

commit transaction;
