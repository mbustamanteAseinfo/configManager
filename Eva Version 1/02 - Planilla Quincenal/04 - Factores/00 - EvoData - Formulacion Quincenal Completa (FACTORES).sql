/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

begin transaction

delete from [sal].[fat_factores_tipo_planilla] where [fat_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Quincenal' and tpl_codmon = 'PAB');
delete from [sal].[ftp_formulacion_tipos_planilla] where [ftp_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Quincenal' and tpl_codmon = 'PAB');

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '1c322de6-4789-4232-bc28-a148e5e45a8e'  and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1c322de6-4789-4232-bc28-a148e5e45a8e','EmpleadoParticipa','Determina si el empleado participa del calculo de esta planilla','Function EmpleadoParticipa()

b = Emp_InfoSalario.Fields("EMP_FECHA_INGRESO").Value <= Pla_Periodo.Fields("PPL_FECHA_FIN").Value _ 
  and Emp_InfoSalario.Fields("dpl_suspendido").Value = "N" and Emp_InfoSalario.Fields("emp_estado").Value = "A"

if not PermisosSinGoceSueldo.EOF then
   if PermisosSinGoceSueldo.Fields("TNN_FECHA_DEL").Value <= Pla_Periodo.Fields("PPL_FECHA_INI").Value and _
      PermisosSinGoceSueldo.Fields("TNN_FECHA_AL").Value >= Pla_Periodo.Fields("PPL_FECHA_FIN").Value then
      b = False
   end if
end if

if not pagos_vacacion_estaquincena.EOF then
   b = False
end if

if not VacacionesRenunciadas.EOF then
   b = True
end if

if not TNT_Extenso.EOF then
   b = False
end if

EmpleadoParticipa = b

End Function','boolean','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'dd8c90cd-3e65-431a-b301-65b19c4c1f35' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('dd8c90cd-3e65-431a-b301-65b19c4c1f35','DiasQuincena','Cantidad de días del período para el empleado','Function DiasQuincena()

DiasQuincena = 15.00

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '86d5188e-2120-49b9-8b98-a57a2d7772bd' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('86d5188e-2120-49b9-8b98-a57a2d7772bd','DiasTrabajados','Almacena la cantidad de días trabajados por el empleado en el período','Function DiasTrabajados()

Dias = 15
tnt = 0
horas = 0.00

horas = Emp_InfoSalario.Fields("emp_num_horas_x_mes").Value / 2

if not (pagos_vacacion_estaquincena.BOF or pagos_vacacion_estaquincena.EOF) then
   Dias = 15 - cdbl(pagos_vacacion_estaquincena.Fields("dpv_dias").Value)
   
   if Dias < 0 then
      Dias = 0
   end if
end if

if not (VacacionesRenunciadas.BOF or VacacionesRenunciadas.EOF) then
	Dias = Dias + cdbl(VacacionesRenunciadas.Fields("dva_dias").Value)

   if Dias > 15 then
      Dias = 15
   end if
	
end if 

if not SalarioNuevoIngreso.EOF then
   Dias = CInt( SalarioNuevoIngreso.Fields("dias").Value )
   horas = CDbl( SalarioNuevoIngreso.Fields("horas").Value )
end if

if not DiasPSGS.EOF then
   Dias = Dias - cint(DiasPSGS.Fields("DIAS").Value)
   horas = cdbl(DiasPSGS.Fields("HORAS").Value)
end if

if horas <= 0 then
   horas = 0
end if

Factores("HorasTrabajadas").Value = horas

if Dias > 0 then
   DiasTrabajados = Dias - tnt
else
   DiasTrabajados = Dias
end if

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'c1e6999c-9b4d-4a8d-825b-ef938d1891d1' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c1e6999c-9b4d-4a8d-825b-ef938d1891d1','SalarioActual','Salario Actual','Function SalarioActual()

salq = 0

'' - CALCULA SALARIO ACTUAL
if isnull( cdbl(Emp_InfoSalario.Fields("EMP_SALARIO").Value) ) then
  salq = 0
else
  salq = (cdbl(Emp_InfoSalario.Fields("EMP_SALARIO").Value))
end if
   
SalarioActual = salq

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '6bbc67e0-c6cd-490c-9257-2d496a48735d' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6bbc67e0-c6cd-490c-9257-2d496a48735d','SueldoQuincenal','Salario de la Quincena','Function SueldoQuincenal()

S = 0
Dias = Factores("DiasTrabajados").Value
horas = Factores("HorasTrabajadas").Value 

if not PagoProporcionalIncremento.EOF then
   S = cdbl(PagoProporcionalIncremento.Fields("SALARIO_ACTUAL").Value) + cdbl(PagoProporcionalIncremento.Fields("SALARIO_PREVIO").Value)
else
   if not SalarioNuevoIngreso.EOF then
      S = CDbl(SalarioNuevoIngreso.Fields("salario_proporcional").Value )
      Dias = CDbl(SalarioNuevoIngreso.Fields("dias").Value)
   else
      if not DiasPSGS.EOF then
         S = CDbl(DiasPSGS.Fields("HORAS").Value) * CDbl(Emp_InfoSalario.Fields("emp_salario_hora").Value)
      else
         S = (cdbl(Emp_InfoSalario.Fields("emp_salario").Value)/30) * Factores("DiasTrabajados").Value
         
         ''if not SalarioImpar.EOF and not SalarioImpar.BOF then
         ''   S = CDbl(SalarioImpar.Fields("pago").Value)
         ''end if
         
      end if
      
      if not DiasPendientesPagoNuevoIngreso.EOF then
         if CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value) > 0 then
            Dias = Dias + CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value)
            Factores("DiasTrabajados").Value = Factores("DiasTrabajados").Value + Dias
            S = round(S + cdbl(DiasPendientesPagoNuevoIngreso.Fields("salario_proporcional").Value),2)
         end if
      end if
   end if
end if

if not isnull(Factores("SueldoQuincenal").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SueldoQuincenal").CodTipoIngreso, _
                             S, "PAB", horas, "Horas"
end if

SueldoQuincenal = S

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '5170a1c5-de74-4d09-b6dd-e324c59613ac' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5170a1c5-de74-4d09-b6dd-e324c59613ac','GastoRepresentacion','Valor de Gastos de Representacion','Function GastoRepresentacion()

S = 0
Dias = Factores("DiasTrabajados").Value
if Dias > 15 then
   Dias = 15
end if
horas = Factores("HorasTrabajadas").Value

''if not PagoProporcionalIncremento.EOF then
''   S = cdbl(PagoProporcionalIncremento.Fields("SALARIO_ACTUAL").Value) + cdbl(PagoProporcionalIncremento.Fields("SALARIO_PREVIO").Value)
''else
   if not GastoRepNuevoIngreso.EOF then
      S = CDbl(GastoRepNuevoIngreso.Fields("salario_proporcional").Value )
      Dias = CDbl(GastoRepNuevoIngreso.Fields("dias").Value)
   else
      S = (cdbl(Emp_InfoSalario.Fields("emp_gastos_representacion").Value)/30) * Dias
      
      ''if not GastoRepImpar.EOF and not GastoRepImpar.BOF then
      ''   S = CDbl(GastoRepImpar.Fields("pago").Value)
      ''end if
         
      if not DiasPendientesPagoNuevoIngreso.EOF then
         if CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value) > 0 then
            Dias = Dias + CInt(DiasPendientesPagoNuevoIngreso.Fields("dias").Value)
            S = round(S + cdbl(DiasPendientesPagoNuevoIngreso.Fields("gasto_rep_proporcional").Value),2)
         end if
      end if
   end if
''end if

if not isnull(Factores("GastoRepresentacion").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("GastoRepresentacion").CodTipoIngreso, _
                             S, "PAB", horas, "Horas"
end if

GastoRepresentacion = S

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'fe0ffacf-fa45-4ecc-8748-5e70b6b21467' and fac_codpai = 'pa';

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '0894c89e-3154-40a8-adef-5fac024b0201' and fac_codpai = 'pa';

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'eefe89cd-86f4-4847-8c8c-f84a3dcd5ed4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('eefe89cd-86f4-4847-8c8c-f84a3dcd5ed4','DiasIncapacidad','Dias de Incapacidad','Function DiasIncapacidad()

DiasIncapacidad = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '8d60069a-0beb-41ea-977f-600fc6e41574' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8d60069a-0beb-41ea-977f-600fc6e41574','DiasDescuentoIncap','Dias Descuento Incapacidad','Function DiasDescuentoIncap()

DiasDescuentoIncap = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '42d8a080-a9a5-47f1-8229-99bb6ed71efc' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('42d8a080-a9a5-47f1-8229-99bb6ed71efc','DescuentoIncapacidad','Descuento por Incapacidad','Function DescuentoIncapacidad()

di = 0.00
vi = 0.00

if 1 = 2 then
if not Emp_Incapacidades.EOF then
   do until Emp_Incapacidades.EOF        
      di = di + CDbl(Emp_Incapacidades.Fields("pie_horas_descontar").Value) / 8.00
      vi = vi + round(CDbl(Emp_Incapacidades.Fields("PIE_VALOR_A_DESCONTAR").Value), 2)
    Emp_Incapacidades.MoveNext
   loop
end if
end if

Factores("DiasDescuentoIncap").Value = di
DescuentoIncapacidad = vi

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '72d579d4-c281-4569-b4e9-f61ed36bdae3' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('72d579d4-c281-4569-b4e9-f61ed36bdae3','IngresoIncapacidad','Obtiene el monto a pagar en concepto de incapacidad','Function IngresoIncapacidad()

valor = 0
dias = 0
diasPagados = 0
S = 0
horas = 0

''if not DiasPagadosIncapacidad.EOF then
''   diasPagados = CDbl(DiasPagadosIncapacidad.Fields("DIAS_PAGADOS").Value)
''end if

while not Emp_Incapacidades.EOF
   valor = valor + CDbl(Emp_Incapacidades.Fields("PIE_VALOR_A_PAGAR").Value)
   if CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value) > 0 then
      dias = dias + CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value) / 8
      horas = horas + CDbl(Emp_Incapacidades.Fields("pie_horas_pagar").Value)
   else
      dias = dias + CDbl(Emp_Incapacidades.Fields("PIE_DIAS").Value)
      horas = horas + CDbl(Emp_Incapacidades.Fields("PIE_DIAS").Value) * 8 
   end if

   Emp_Incapacidades.MoveNext
wend

dias = round(dias, 2)

if dias = 15 then
   valor = CDbl(Emp_InfoSalario.Fields("emp_salario").Value) / 2.00
end if

''if (diasPagados + dias) > 36 then
''   valor = 0
''end if

if valor > 0 then
   S = CDbl(Factores("SueldoQuincenal").Value)
   if diasPagados > 0 then
      if (dias + diasPagados) >= 36 then
         S = 0
      else
         S = S - valor
      end if
   else
      S = S - valor
   end if
   Factores("SueldoQuincenal").Value = S
end if

if not isnull(Factores("SueldoQuincenal").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SueldoQuincenal").CodTipoIngreso, _
                             valor * -1.00, "PAB", horas * -1, "Horas"
end if


if not isnull(Factores("IngresoIncapacidad").CodTipoIngreso) and valor > 0 then
   Factores("DiasIncapacidad").Value = dias

   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("IngresoIncapacidad").CodTipoIngreso, _
                             valor, "PAB", horas, "Horas"
end if

IngresoIncapacidad = valor

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '1050797b-a815-4051-a694-2221f8690858' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1050797b-a815-4051-a694-2221f8690858','HorasTNT','Cantidad de horas no trabajadas por el empleado','Function HorasTNT()

HorasTNT = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'ff7a9453-e976-4dd6-a080-4d8c06ac814d' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ff7a9453-e976-4dd6-a080-4d8c06ac814d','DescuentoTNT','Descuento por Tiempo no Trabajado','Function DescuentoTNT()
dnt = 0.00
sum = 0.00

if not Emp_TmpNoTrabajado.EOF and 1 = 2 then
   do until Emp_TmpNoTrabajado.EOF
      if not isnull(Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value) and not isnull(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value) and Emp_TmpNoTrabajado.Fields("tnn_codppl").Value = Pla_Periodo.Fields("PPL_CODPPL").Value then
         if Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value > 0 and not isnull(Emp_TmpNoTrabajado.Fields("tnt_codtig").Value) then
            agrega_ingresos_historial Agrupadores, _
			                 IngresosEstaPlanilla, _
			                 Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
			                 Pla_Periodo.Fields("PPL_CODPPL").Value, _
			                 Emp_TmpNoTrabajado.Fields("tnt_codtig").Value, _
			                 cdbl(Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value), _
			                 "PAB", _
			                 ((cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value) + CDbl(Emp_TmpNoTrabajado.Fields("tnn_num_mins").Value) / 60.00) / 8) + cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value), _
							   "Horas"						                 
            
            Emp_TmpNoTrabajado.Fields("tnn_aplicado_planilla").Value = 1
            Factores("DiasTrabajados").Value = Factores("DiasTrabajados").Value - ((Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value / 8) + Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value)
            Factores("SueldoQuincenal").Value = Factores("SueldoQuincenal").Value - Emp_TmpNoTrabajado.Fields("tnn_valor_a_pagar").Value
         end if
         
         if Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value > 0 and not isnull(Emp_TmpNoTrabajado.Fields("tnt_codtdc").Value) then
            sum = sum + Round(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value, 2) 
            dnt = dnt + round(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value, 2) * 8 + round(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value, 2)
            
            agrega_descuentos_historial Agrupadores, _
			            DescuentosEstaPlanilla, _
			            Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
			            Pla_Periodo.Fields("PPL_CODPPL").Value, _
			            Emp_TmpNoTrabajado.Fields("tnt_codtdc").Value, _
			            round(cdbl(Emp_TmpNoTrabajado.Fields("tnn_valor_a_descontar").Value), 2), 0, 0, _
			            "PAB", _
			            ((cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_horas").Value) + CDbl(Emp_TmpNoTrabajado.Fields("tnn_num_mins").Value) / 60.00) ) + cdbl(Emp_TmpNoTrabajado.Fields("tnn_num_dias").Value) * 8, _
			            "Horas"
			Emp_TmpNoTrabajado.Fields("tnn_aplicado_planilla").Value = 1       
                
        end if
      end if
      
      Emp_TmpNoTrabajado.MoveNext
   loop
end if

Factores("HorasTNT").Value = dnt
DescuentoTNT = sum

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '414ac74e-04fb-4441-b8ca-f50162b95dbb' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('414ac74e-04fb-4441-b8ca-f50162b95dbb','OtrosIngresos','Otros Ingresos','Function OtrosIngresos()

o = 0.00
horas = 0.00

if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      vc = round(CDbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)
      horas = CDbl(Emp_OtrosIngresos.Fields("oin_num_horas").Value)
      
      Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   cint(Emp_OtrosIngresos.Fields("OIN_CODTIG").Value), _
                                   vc, cstr(Emp_OtrosIngresos.Fields("oin_codmon").Value), horas, "Horas"
      o = o + vc

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos = o

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '77ebc94e-3505-46e0-9f32-b6c4475d1e6b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('77ebc94e-3505-46e0-9f32-b6c4475d1e6b','DevRenta','Devolucion de Renta','Function DevRenta()

DevRenta = o

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '723cfb33-aea2-434d-a573-56e93fb236b6' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('723cfb33-aea2-434d-a573-56e93fb236b6','Extraordinario','Valor total de horas extras','Function Extraordinario()
vc = 0
ex = 0
hor = 0


   if not Emp_HorasExtras.EOF then
      do until Emp_HorasExtras.EOF
         vc = round(CDbl(Emp_HorasExtras.Fields("ext_valor_a_pagar").Value), 2)
         hor= round(CDbl(Emp_HorasExtras.Fields("ext_num_horas").Value) + CDbl(Emp_HorasExtras.Fields("ext_num_mins").Value) / 60.00, 2)
         
         agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   Emp_HorasExtras.Fields("the_codtig").Value, _
                                   vc, "PAB", hor, "Horas"
         Emp_HorasExtras.Fields("ext_aplicado_planilla").Value = 1
         ex = ex + vc
         Emp_HorasExtras.MoveNext
      loop
   end if


Extraordinario = ex
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '0d214ad6-e1ef-4500-aa69-51fbe539c264' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0d214ad6-e1ef-4500-aa69-51fbe539c264','SalarioBruto','Cálculo del Salario Bruto','Function SalarioBruto()
dep = Factores("DescuentoTNT").Value + Factores("DescuentoIncapacidad").Value 

if dep > Factores("SueldoQuincenal").Value then
   if Factores("DescuentoTNT").Value = 0 then
      '' Solo se descuenta incapacidad
      Factores("DescuentoIncapacidad").Value = Factores("SueldoQuincenal").Value

   elseif Factores("DescuentoIncapacidad").Value = 0 then
      '' Solo se descuenta TNT
      Factores("DescuentoTNT").Value = Factores("SueldoQuincenal").Value 

   else
      '' Los dos tienen valor, prioriza corregiendo primero el TNT
      dep = Factores("SueldoQuincenal").Value - Factores("DescuentoTNT").Value - Factores("DescuentoIncapacidad").Value 
      
      if dep < 0 then
            msgbox "El valor de los descuentos de tiempo no trabajado + incapacidad + descuentos ciclicos son mayores que el salario quincenal del empleado con código" & Emp_InfoSalario.Fields("emp_codigo").Value
      else     
        ''if Factores("DescuentoTNT").Value + dep > 0 then
        ''    Factores("DescuentoTNT").Value = Factores("DescuentoTNT").Value + dep
        ''else
        if Factores("DescuentoIncapacidad").Value + dep > 0 then
            Factores("DescuentoIncapacidad").Value = Factores("DescuentoIncapacidad").Value + dep
        end if
      end if
    end if
end if

if not isnull(Factores("DescuentoIncapacidad").CodTipoDescuento) and Factores("DescuentoIncapacidad").Value > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescuentoIncapacidad").CodTipoDescuento, _
                               Factores("DescuentoIncapacidad").Value, 0, 0, _ 
                               "PAB", _
                               Factores("DiasDescuentoIncap").Value, _
                               "Dias"
end if

if not isnull(Factores("DescuentoTNT").CodTipoDescuento) and Factores("DescuentoTNT").Value > 0 and 1 = 2 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescuentoTNT").CodTipoDescuento, _
                               Factores("DescuentoTNT").Value, 0, 0, _
                               "PAB", _
                               Factores("HorasTNT").Value, _
                               "Dias"                               
end if

Var_SalarioBruto = Factores("SueldoQuincenal").Value + _
                   Factores("Extraordinario").Value + _
                   Factores("GastoRepresentacion").Value + _                   
                   Factores("IngCiclicos").Value + _
                   Factores("DevRenta").Value + _
                   Factores("OtrosIngresos").Value - _
                   Factores("DescuentoTNT").Value - _
                   Factores("DescuentoIncapacidad").Value + _
                   Factores("Retroactivo").Value + _
                   Factores("RetroactivoGastoRep").Value

if var_salariobruto < 0 then
   var_salariobruto = 0
end if

SalarioBruto = var_salariobruto
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'f0017293-0f88-4516-b35c-4964d32e292b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f0017293-0f88-4516-b35c-4964d32e292b','OtrosDescAplicaLegal','Procesa Otros Descuentos asociados al periodo de pago afectos a descuentos legales','Function OtrosDescAplicaLegal()
liquido = Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value
   
sum = 0
valor = 0 
horas = 0.00

if Emp_OtrosDescuentos_AplicaLegal.RecordCount > 0 then
   Emp_OtrosDescuentos_AplicaLegal.MoveFirst
   do until Emp_OtrosDescuentos_AplicaLegal.EOF
      valor = round(Emp_OtrosDescuentos_AplicaLegal.Fields("ods_valor_a_descontar").Value, 2)
      horas = CDbl(Emp_OtrosDescuentos_AplicaLegal.Fields("ods_num_horas").Value)
   
      if valor > liquido then
         Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_APLICADO_PLANILLA").Value = 0
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_APLICADO_PLANILLA").Value = 1
         
         if horas > 0 then
         	agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", horas, "Horas"
         else
         	agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos_AplicaLegal.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, "Dias"
         end if
      end if
      Emp_OtrosDescuentos_AplicaLegal.MoveNext
   loop
end if

if sum > 0 then
   Factores("SalarioBruto").Value = Factores("SalarioBruto").Value - sum
end if

OtrosDescAplicaLegal = sum
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '85ae6a9f-ceff-45dd-9cff-af297e52b69f' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('85ae6a9f-ceff-45dd-9cff-af297e52b69f','GrabaHistoriales','Funcion que graba en las tablas historicas de ingresos, descuentos y reservas los ingresos','Function GrabaHistoriales()

GrabaHistoriales = 0
salario_total = 0

salario_total = Factores("SueldoQuincenal").Value

tiempo = Factores("DiasTrabajados").Value - Factores("DiasIncapacidad").Value

''if Emp_InfoSalario.Fields("emp_codigo").Value = 96 then
''   msgbox "DiasTrabajados: " & cstr(Factores("DiasTrabajados").Value) & ", DiasIncapacidad: " & cstr(Factores("DiasIncapacidad").Value) & ", tiempo: " & cstr(tiempo)
''end if

'' Graba en los historiales los valores de sueldo quincenal
'' ------------------------------------------------------------------------------------------
''if not isnull(Factores("SueldoQuincenal").CodTipoIngreso) and Factores("SueldoQuincenal").Value > 0 then
''   agrega_ingresos_historial Agrupadores, _
''                             IngresosEstaPlanilla, _
''                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
''                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
''                             Factores("SueldoQuincenal").CodTipoIngreso, _
''                             salario_total, "PAB", tiempo, "Dias"
''end if

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'f9dc52a5-30ea-4957-9f17-54954d0a4a7e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f9dc52a5-30ea-4957-9f17-54954d0a4a7e','SSBaseCalculo','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo()

SSBaseCalculo = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '9c60e57a-b6c2-43cf-89b6-61cb8b122bf9' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9c60e57a-b6c2-43cf-89b6-61cb8b122bf9','SeguroSocialPatrono','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono()

SeguroSocialPatrono = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'f62949ca-2c72-48d0-a55e-b055b0901064' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f62949ca-2c72-48d0-a55e-b055b0901064','SeguroSocial','Cálculo del descuento del Seguro Social','Function SeguroSocial()

patAnterior = 0
afectoAnterior = 0
descAnterior = 0
patEspecial = 0
   
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_social").Value = "N" then
   SeguroSocial = cuota
   Exit Function
end if

'' No calcula descuentos legales para empleados temporales
''if not Factores("tieneContratoPermane").Value then
''   SeguroSocial = 0
''   exit function
''end if
   
if Factores("SSBaseCalculo").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)
''   pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)

   afectoAnterior = Factores("SSBaseCalculo").Value
      
   cuota = (por_cuota / 100) * afectoAnterior - descAnterior

''   patEspecial = (pat_espec / 100) * (afectoAnterior - descAnterior)

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * afectoAnterior - patAnterior

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial").CodTipoDescuento, _
                               cuota, patronal, Agrupadores("BaseCalculoSeguroSocial").Value, _
                               "PAB", 0, ""
end if

Factores("SeguroSocialPatrono").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if

SeguroSocial = cuota

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '48ea6d65-29b5-4da8-9dab-4f0e5592bf0d' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('48ea6d65-29b5-4da8-9dab-4f0e5592bf0d','SegEducativoBase','Base para calculo de Seguro Educativo','Function SegEducativoBase()

SegEducativoBase = Agrupadores("BaseCalculoSeguroEducativo").Value 

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '59c6d4c3-e1d5-46d0-9641-ea7994f7e124' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('59c6d4c3-e1d5-46d0-9641-ea7994f7e124','SegEducativoPatronal','Parte Patronal del Seguro Educativo','Function SegEducativoPatronal()

SegEducativoPatronal = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '3a659999-3b6a-4906-845c-8ac750e90c8a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3a659999-3b6a-4906-845c-8ac750e90c8a','SegEducativo','Valor del Descuento de Seguro Educativo','Function SegEducativo()
patAnterior = 0
afectoAnterior = 0
descAnterior = 0   
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_educativo").Value = "N" then
   SegEducativo = cuota
   Exit Function
end if

if Factores("SegEducativoBase").Value >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_DESC").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_PAT").Value)
   
   afectoAnterior = cDbl(Factores("SegEducativoBase").Value)
   cuota = round(por_cuota / 100.0 * afectoAnterior, 4) - descAnterior

   if cuota < 0 then cuota = 0
 
   patronal = round(pat_cuota / 100.0 * afectoAnterior, 4) - patAnterior

   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo").CodTipoDescuento, _
                               cuota, patronal, Factores("SegEducativoBase").Value, _
                               "PAB", 0, ""
end if

Factores("SegEducativoPatronal").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro educativo
if not isnull(Factores("SegEducativoPatronal").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SegEducativoPatronal").CodTipoReserva, _
                             patronal, "PAB", 0 , ""
end if

SegEducativo = cuota

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'fd68b0c7-2e7c-4ad5-89e4-fab4f61c8f0b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('fd68b0c7-2e7c-4ad5-89e4-fab4f61c8f0b','ISRBaseCalculoGRep','Base para calculo de renta para gastos de representacion','Function ISRBaseCalculoGRep()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0

base = Agrupadores("IngresosRentaGRepPTY").Value 

if base < 0 then
   base = 0
end if

ISRBaseCalculoGRep = base
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'c5dc36f7-0685-4a27-a9a5-824f8aeaa292' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c5dc36f7-0685-4a27-a9a5-824f8aeaa292','DevolucionDescRenta','Devolucion por Descuento de Renta','Function DevolucionDescRenta()

DevolucionDescRenta = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'a22c44d2-0eba-4a41-9784-90484819f221' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('a22c44d2-0eba-4a41-9784-90484819f221','CreditoISRGastoRep','Valor del Descuento por Gasto de Representacion','Function CreditoISRGastoRep()

CreditoISRGastoRep = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = 'd1465930-c563-44d2-98a7-b27f9461b79e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d1465930-c563-44d2-98a7-b27f9461b79e','ISR','Descuento de Impuesto sobre la Renta','Function ISR()
''RENTA PLANILLA QUINCENAL
ingreso_planilla = CDbl(Factores("ISRBaseCalculo").Value)
Datos_Renta.Fields("RAP_INGRESO_PLANILLA").Value = ingreso_planilla

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculo").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF then
  ISR = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00

continuar = 1

if not ISR_Salario.EOF and not ISR_Salario.BOF then
  salario_quincenal = CDbl(ISR_Salario.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value)
    else
       valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value) * ingreso_planilla / salario_quincenal
       continuar = 0
    end if
  end if
  
  acumulado = CDbl(ISR_Salario.Fields("rap_acumulado").Value)
  proyectado = CDbl(ISR_Salario.Fields("rap_proyectado").Value)
  desc_legal = CDbl(ISR_Salario.Fields("rap_desc_legal").Value)
  isr_anual = CDbl(ISR_Salario.Fields("isr_anual").Value)
  
  ingreso_anual_planilla = acumulado + proyectado + ingreso_planilla - desc_legal
end if

if valor < 0 then
  valor = 0
end if

''if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
''  writeLog ("1. valor: " & CStr(valor) & ", continuar: " & CStr(continuar) & ", ingreso_anual_planilla: " & CStr(ingreso_anual_planilla))
''end if

if continuar = 1 then
  if ingreso_anual_planilla > 0 then

    TablaISR.MoveFirst
    if not (TablaISR.EOF and TablaISR.BOF) then
      do until TablaISR.EOF
        if ingreso_anual_planilla >= TablaISR.Fields("ISR_DESDE").Value and ingreso_anual_planilla <= TablaISR.Fields("ISR_HASTA").Value then
          isr_anual_planilla = ((ingreso_anual_planilla - TablaISR.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR.Fields("ISR_PCT").Value /100.00)) + TablaISR.Fields("ISR_VALOR").Value 
        end if
        TablaISR.MoveNext
      loop
    end if
    
    if isr_anual_planilla > isr_anual then
      valor = valor + (isr_anual_planilla - isr_anual)
    end if
  end if
end if

if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
  writeLog ("2. isr_anual: " & CStr(isr_anual) & ", isr_anual_planilla: " & CStr(isr_anual_planilla) & ", valor: " & CStr(valor))
end if

if valor < 0 then
  valor = 0
end if

if valor > 0 then
   valor = round(valor * 100.00 + 0.100)/100
   Datos_Renta.Fields("rap_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR = valor

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '82e83429-b3d4-4dd6-ac0c-c0749d423e48' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('82e83429-b3d4-4dd6-ac0c-c0749d423e48','ISR_GASTO_REP','Factor encargado de calcular el impuesto sobre la renta aplicado al Gasto de Representación','Function ISR_GASTO_REP()
''RENTA PLANILLA QUINCENAL

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculoGRep").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
  ISR_GASTO_REP = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00

continuar = 1

ingreso_planilla = CDbl(Factores("ISRBaseCalculoGRep").Value)
Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = ingreso_planilla

if not ISR_GastoRep.EOF and not ISR_GastoRep.BOF then
  salario_quincenal = CDbl(ISR_GastoRep.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value)
    else
       valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * ingreso_planilla / salario_quincenal
       continuar = 0
    end if
  end if
  
  acumulado = CDbl(ISR_GastoRep.Fields("rag_acumulado").Value)
  proyectado = CDbl(ISR_GastoRep.Fields("rag_proyectado").Value)
  desc_legal = CDbl(ISR_GastoRep.Fields("rag_desc_legal").Value)
  isr_anual = CDbl(ISR_GastoRep.Fields("isr_anual").Value)
  
  ingreso_anual_planilla = acumulado + proyectado + ingreso_planilla - desc_legal
end if

if valor < 0 then
  valor = 0
end if

''if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
''  writeLog ("1. valor: " & CStr(valor) & ", continuar: " & CStr(continuar) & ", ingreso_anual_planilla: " & CStr(ingreso_anual_planilla))
''end if

if continuar = 1 then
  if ingreso_anual_planilla > 0 then

    TablaISR_GRep.MoveFirst
    if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
      do until TablaISR_GRep.EOF
        if ingreso_anual_planilla >= TablaISR_GRep.Fields("ISR_DESDE").Value and ingreso_anual_planilla <= TablaISR_GRep.Fields("ISR_HASTA").Value then
          isr_anual_planilla = ((ingreso_anual_planilla - TablaISR_GRep.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)) + TablaISR_GRep.Fields("ISR_VALOR").Value 
        end if
        TablaISR_GRep.MoveNext
      loop
    end if
    
    if isr_anual_planilla > isr_anual then
      valor = valor + (isr_anual_planilla - isr_anual)
    end if
  end if
end if

''if Emp_InfoSalario.Fields("EMP_CODIGO").Value = 2 then
''  writeLog ("2. isr_anual: " & CStr(isr_anual) & ", isr_anual_planilla: " & CStr(isr_anual_planilla) & ", valor: " & CStr(valor))
''end if

if valor < 0 then
  valor = 0
end if

if valor > 0 then
   valor = round(valor * 100.00 + 0.100)/100
   Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR_GASTO_REP = valor

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '05b6bda7-ac4c-44f2-a9df-12e73406d28e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('05b6bda7-ac4c-44f2-a9df-12e73406d28e','PatronalProfuturoPA','Calculo de aporte patronal AFP PA','Function PatronalProfuturoPA

PatronalProfuturoPA = 0 

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '36a139d3-3575-4154-8865-3f00cf7689ac' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('36a139d3-3575-4154-8865-3f00cf7689ac','PatronalProfuturoIDM','Cuota patronal profuturo de Indemnizacion','Function PatronalProfuturoIDM()

PatronalProfuturoIDM = 0 

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '9559bb84-5dfe-4a9d-aad8-f581d8cbe0f4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9559bb84-5dfe-4a9d-aad8-f581d8cbe0f4','OtrosDescuentos','Procesa Otros Descuentos asociados al periodo de pago','Function OtrosDescuentos()
liquido = Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value
   
sum = 0
valor = 0 
horas = 0.00

if Emp_OtrosDescuentos.RecordCount > 0 then
   Emp_OtrosDescuentos.MoveFirst
   do until Emp_OtrosDescuentos.EOF
      valor = round(Emp_OtrosDescuentos.Fields("ods_valor_a_descontar").Value, 2)
      horas = CDbl(Emp_OtrosDescuentos.Fields("ods_num_horas").Value)
   
      if valor > liquido then
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 0
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 1
         
         if horas > 0 then
	         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", horas, "Horas"
         else
	         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, ""
         end if
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if
   
OtrosDescuentos = sum
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '4b75e4c1-472f-4ad5-a3bf-3ed14d5b084b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('4b75e4c1-472f-4ad5-a3bf-3ed14d5b084b','DescCiclicos','Detalle de Descuentos Ciclicos','Function DescCiclicos()
liquido = Factores("IngresoIncapacidad").Value + Factores("SalarioBruto").Value - _
          Factores("SeguroSocial").Value - _
          Factores("SegEducativo").Value - _
          Factores("ISR").Value - _
          Factores("OtrosDescuentos").Value
   
dc = 0.00
vc = 0.00
aplicada = False

IF not (CuotasDescuentosCiclicos.EOF and CuotasDescuentosCiclicos.bof) then

Do Until CuotasDescuentosCiclicos.EOF

        vc = Round(CDbl(CuotasDescuentosCiclicos.Fields("cdc_valor_cobrado").Value), 2)

       '' Si el valor de cuota es cero y el porcentaje es mayor que cero, debo calcular la cuota en el momento
       if vc = 0 and CDbl(CuotasDescuentosCiclicos.Fields("dcc_porcentaje").Value) > 0 then
          for i = 1 to Agrupadores.Count
              if Agrupadores(i).Codigo = cint(CuotasDescuentosCiclicos.Fields("dcc_codagr").Value) then
                 vc = round(Agrupadores(i).Value * cdbl(CuotasDescuentosCiclicos.Fields("dcc_porcentaje").Value) / 100, 2)
                 CuotasDescuentosCiclicos.Fields("cdc_valor_cobrado").Value = vc
                 exit for
              end if
              next
        end if

        If (liquido - vc) > 0 Then
            aplicada = True
            liquido = liquido - vc
            dc = dc + vc
            CuotasDescuentosCiclicos.Fields("cdc_fecha_descuento").Value = Pla_Periodo.Fields("PPL_FECHA_PAGO").Value
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 1

            agrega_descuentos_historial Agrupadores, _
                                        DescuentosEstaPlanilla, _
                                        Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                        Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                        CuotasDescuentosCiclicos.Fields("dcc_codtdc").Value, _
                                        vc, 0, 0, "PAB", 0, ""
        Else
            aplicada = False
            ''CuotasDescuentosCiclicos.Fields("CDC_VENCIMIENTO").Value = Null
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 0            
        End If

   CuotasDescuentosCiclicos.MoveNext
 Loop
else
   dc=0.00
end if

DescCiclicos = dc
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '953b2ed4-e94a-4fce-a966-f9dfb5816314' and fac_codpai = 'pa';

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

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:37 AM */

delete from [sal].[fac_factores] where [fac_codigo] = '6e65914f-76c3-4adc-ba53-804823b17246' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6e65914f-76c3-4adc-ba53-804823b17246','HorasTrabajadas','Horas trabajadas en el periodo','Function HorasTrabajadas

HorasTrabajadas = 0.00

End Function','double','pa',0);

commit transaction;
