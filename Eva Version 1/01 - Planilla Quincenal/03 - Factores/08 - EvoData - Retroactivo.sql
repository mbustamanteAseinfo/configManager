/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:41 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'fe0ffacf-fa45-4ecc-8748-5e70b6b21467';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('fe0ffacf-fa45-4ecc-8748-5e70b6b21467','Retroactivo','Retroactivo del salario','Function Retroactivo()

valor = 0
dias = 0

if not (RetroactivoSalario.EOF and RetroactivoSalario.BOF) then
   valor = CDbl(RetroactivoSalario.Fields("PIR_MONTO_RETROACTIVO").Value)
   dias = CDbl(RetroactivoSalario.Fields("PIR_DIAS_RETROACTIVO").Value)
   
   if not isnull(Factores("Retroactivo").CodTipoIngreso) and valor > 0 then
      agrega_ingresos_historial Agrupadores, _
                                     IngresosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Factores("Retroactivo").CodTipoIngreso, _
                                     valor, "PAB", dias, "Dias"
   end if
end if

Retroactivo = valor

End Function','double','pa',0);

commit transaction;
