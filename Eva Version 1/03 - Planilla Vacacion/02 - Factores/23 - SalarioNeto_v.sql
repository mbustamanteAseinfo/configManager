/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:21 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '9b5cea25-b38d-4e75-9af0-a5a4c0499a50';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9b5cea25-b38d-4e75-9af0-a5a4c0499a50','SalarioNeto_v','Salario Neto a Pagar al Empleado','Function SalarioNeto_v()
liquido = Factores("SalarioBruto_v").Value - _
          Factores("SeguroSocial_v").Value - _
          Factores("SegEducativo_v").Value - _
          Factores("ISR_v").Value - _
          Factores("ISR_GASTO_REP_v").Value - _
          Factores("OtrosDescuentos_v").Value - _
          Factores("DescCiclicos_v").Value

'' Almacena en las reservas el salario neto pagado
if not isnull(Factores("SalarioNeto_v").CodTipoReserva) and liquido > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario_Vacaciones.Fields("emp_codigo").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SalarioNeto_v").CodTipoReserva, _
                             liquido, "PAB", 0, ""
end if

''if isnull(liquido) then
''   msgbox "Liquido Nulo .. Empleado "  & Emp_InfoSalario_Vacaciones.Fields("emp_codigo").Value
''end if

''if Factores("SSBaseCalculo_v").Value < 0 then msgbox "Es Menor que cero"

SalarioNeto_v = liquido
End Function','double','pa',0);

commit transaction;
