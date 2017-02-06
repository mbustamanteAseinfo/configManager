/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:45 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '8e473186-3b82-4b7f-9f25-b5ee874e5124' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8e473186-3b82-4b7f-9f25-b5ee874e5124','IngCiclicos','Cuotas por Ingresos Cíclicos','Function IngCiclicos()
total = 0
cuota = 0

do until CuotasIngresosCiclicos.EOF
    cuota = CuotasIngresosCiclicos.Fields("cic_valor_cuota").Value

IF cuota > 0 and Factores("DiasTrabajados").Value > 0 then
   
    agrega_ingresos_historial Agrupadores, _  
                              IngresosEstaPlanilla, _
                              Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                              Pla_Periodo.Fields("PPL_CODPPL").Value, _
                              CuotasIngresosCiclicos.Fields("igc_codtig").Value, _
                              cuota, "PAB", 0, "Dias"

else
cuota = 0
end if

    total = total + cuota
    CuotasIngresosCiclicos.Fields("cic_aplicado_planilla").Value = 1
    CuotasIngresosCiclicos.MoveNext


loop

IngCiclicos = total
End Function','double','pa',0);

commit transaction;
