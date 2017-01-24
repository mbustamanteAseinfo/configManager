/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:51 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '953b2ed4-e94a-4fce-a966-f9dfb5816314';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('953b2ed4-e94a-4fce-a966-f9dfb5816314','SalarioNeto','Salario Neto a Pagar al Empleado','Function SalarioNeto()
liquido = Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value - _
          Factores("ISR_GASTO_REP").Value - _
          Factores("OtrosDescuentos").Value - _
          Factores("DescCiclicos").Value

'' Almacena en las reservas el salario neto pagado
if not isnull(Factores("SalarioNeto").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SalarioNeto").CodTipoReserva, _
                             liquido, "PAB", 0, ""
end if

if isnull(liquido) then
   msgbox "Liquido Nulo .. Empleado "  & Emp_InfoSalario.Fields("emp_codigo").Value 
end if

if Factores("SSBaseCalculo").Value < 0 then msgbox "Es Menor que cero"

SalarioNeto = liquido
End Function','double','pa',0);

commit transaction;
