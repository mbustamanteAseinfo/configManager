/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:15 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6f18ba36-afc3-4034-b6eb-6d01eb800380' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6f18ba36-afc3-4034-b6eb-6d01eb800380','SalarioNeto_d','Salario Neto a Pagar al Empleado','Function SalarioNeto_d()
liquido = Factores("DecimoTercero").Value + _
          Factores("Decimo_Tercero_GRep").Value + _
          Factores("OtrosIngresos_d").Value - _
          Factores("OtrosDescuentos_d").Value - _          
          Factores("SeguroSocial_d").Value - _
          Factores("SegSocGastoRep").Value - _
          Factores("ISR_d").Value - _
          Factores("ISR_GASTO_REP_d").Value - _
          Factores("DescExcesoXIII").Value - _
          Factores("DescExcesoXIII_GR").Value

'' Almacena en las reservas el salario neto pagado
if not isnull(Factores("SalarioNeto_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SalarioNeto_d").CodTipoReserva, _
                             liquido, "PAB", 0, ""
end if

if isnull(liquido) then
   msgbox "Liquido Nulo .. Empleado "  & Emp_InfoSalario.Fields("emp_codigo").Value 
end if

if Factores("SSBaseCalculo_d").Value < 0 then msgbox "Es Menor que cero"

SalarioNeto_d = liquido
End Function','double','pa',0);

commit transaction;
