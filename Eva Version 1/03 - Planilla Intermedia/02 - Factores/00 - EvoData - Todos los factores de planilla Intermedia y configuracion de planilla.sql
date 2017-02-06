/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

begin transaction
delete from [sal].[fat_factores_tipo_planilla] where [fat_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB');
delete from [sal].[ftp_formulacion_tipos_planilla] where [ftp_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB');


/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '7217DB5E-140E-436F-BC30-A21EEB5098B8' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('7217DB5E-140E-436F-BC30-A21EEB5098B8','aju_EmpleadoParticipa','Determina si el empleado participa del calculo de la planilla de ajustes','Function aju_EmpleadoParticipa ()

participa = false

participa = Emp_InfoSalario_Ajustes.Fields("emp_fecha_ingreso").Value <= Pla_Periodo.Fields("ppl_fecha_fin").Value _    
    and Emp_InfoSalario_Ajustes.Fields("emp_estado").Value = "A"
    

if participa then
   participa = (not Emp_OtrosIngresos.EOF and not Emp_OtrosIngresos.BOF) _
   or (not Emp_HorasExtras.EOF and not Emp_HorasExtras.BOF)
end if


aju_EmpleadoParticipa = participa

End Function','boolean','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'D08AF6E4-0DA0-48A5-A46A-7917F2C90C5D' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('D08AF6E4-0DA0-48A5-A46A-7917F2C90C5D','aju_ISR','Cálculo del impuesto sobre la renta del salario en planilla de ajustes','Function aju_ISR()

''RENTA PLANILLA DE AJUSTE

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
''if Emp_InfoSalario_Ajustes.Fields("dpl_renta").Value = 0 or Factores("ISRBaseCalculo").Value = 0 or DatosRenta.EOF or DatosRenta.BOF then
if Factores("ISRBaseCalculo_aju").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF then
   aju_ISR = valor
   Exit Function
end if

valorNeto = 0
Anual = 0
Restante = 0

AnualISR_Quincenal = 0
AnualISR_Ajuste = 0
ISR_Ajuste = 0


'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA QUINCENAL ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = Datos_Renta.Fields("rap_acumulado").Value + Datos_Renta.Fields("rap_proyectado").Value 

valorNeto = valorNeto - Datos_Renta.Fields("rap_desc_legal").Value 

TablaISR.MoveFirst
if not (TablaISR.EOF and TablaISR.BOF) then
   do until TablaISR.EOF     
      if valorNeto >= TablaISR.Fields("isr_desde").Value and valorNeto <= TablaISR.Fields("isr_hasta").Value then
          AnualISR_Quincenal = ((valorNeto - TablaISR.Fields("isr_excedente").Value ) * ( TablaISR.Fields("isr_pct").Value /100.00)) + TablaISR.Fields("isr_valor").Value
      end if
     TablaISR.MoveNext
   loop
end if




'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA DE AJUSTE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = valorNeto + Factores("ISRBaseCalculo_aju").Value
TablaISR.MoveFirst
if not (TablaISR.EOF and TablaISR.BOF) then
   do until TablaISR.EOF     
      if valorNeto >= TablaISR.Fields("isr_desde").Value and valorNeto <= TablaISR.Fields("isr_hasta").Value then
          AnualISR_Ajuste = ((valorNeto - TablaISR.Fields("isr_excedente").Value ) * ( TablaISR.Fields("isr_pct").Value /100.00)) + TablaISR.Fields("isr_valor").Value
      end if
     TablaISR.MoveNext
   loop
end if

'' Obtiene la diferencia entre el ISR de la quincena y el ISR con el Ajuste
ISR_Ajuste = AnualISR_Ajuste - AnualISR_Quincenal

if not isnull(Factores("aju_ISR").CodTipoDescuento) and ISR_Ajuste > 0 then
   Datos_Renta.Fields("rap_a_descontar").Value = ISR_Ajuste
   Datos_Renta.Fields("rap_ingreso_planilla").Value = Factores("ISRBaseCalculo_aju").Value
   
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("aju_ISR").CodTipoDescuento, _
                               ISR_Ajuste, 0, 0, _
                               "PAB", _
                               0, "Dias"
end if

aju_ISR = ISR_Ajuste

End Function','money','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '5CBE3135-6C4A-46AC-8927-FCACE58FAD04' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5CBE3135-6C4A-46AC-8927-FCACE58FAD04','aju_ISR_GR','Cálculo del impuesto sobre la renta del salario en planilla quincenal, vacaciones, decimo tecero','Function aju_ISR_GR ()

''RENTA PLANILLA DE AJUSTE

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
''if Emp_InfoSalario_Ajustes.Fields("dpl_renta").Value = 0 or Factores("ISRBaseCalculoGRep").Value = 0 or DatosRenta_GastoRep.EOF or DatosRenta_GastoRep.BOF then
if Factores("ISRBaseCalculoGRep_aju").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
   aju_ISR_GR = valor
   Exit Function
end if

valorNeto = 0
Anual = 0
Restante = 0

AnualISR_Quincenal = 0
AnualISR_Ajuste = 0
ISR_Ajuste = 0

'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA QUINCENAL ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = Datos_Renta_Gastos_Rep.Fields("rag_acumulado").Value + Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value 
valorNeto = valorNeto - Datos_Renta_Gastos_Rep.Fields("rag_desc_legal").Value 
TablaISR_GRep.MoveFirst
if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
   do until TablaISR_GRep.EOF
      if valorNeto >= TablaISR_GRep.Fields("isr_desde").Value and valorNeto <= TablaISR_GRep.Fields("isr_hasta").Value then
          AnualISR_Quincenal = ((valorNeto - TablaISR_GRep.Fields("isr_excedente").Value ) * ( TablaISR_GRep.Fields("isr_pct").Value /100.00)) + TablaISR_GRep.Fields("isr_valor").Value 
      end if
     TablaISR_GRep.MoveNext
   loop
end if

'''''''''''''''' CALCULA EL ISR PARA LA PLANILLA DE AJUSTE ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

valorNeto = valorNeto + Factores("ISRBaseCalculoGRep_aju").Value
TablaISR_GRep.MoveFirst
if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
   do until TablaISR_GRep.EOF
      if valorNeto >= TablaISR_GRep.Fields("isr_desde").Value and valorNeto <= TablaISR_GRep.Fields("isr_hasta").Value then
          AnualISR_Ajuste = ((valorNeto - TablaISR_GRep.Fields("isr_excedente").Value ) * ( TablaISR_GRep.Fields("isr_pct").Value /100.00)) + TablaISR_GRep.Fields("isr_valor").Value 
      end if
      TablaISR_GRep.MoveNext
   loop
end if

'' Obtiene la diferencia entre el ISR de la quincena y el ISR con el Ajuste
ISR_Ajuste = AnualISR_Ajuste - AnualISR_Quincenal

if not isnull(Factores("aju_ISR_GR").CodTipoDescuento) and ISR_Ajuste > 0 then
   Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = ISR_Ajuste
   Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = Factores("ISRBaseCalculoGRep_aju").Value
     
    agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("aju_ISR_GR").CodTipoDescuento, _
                               ISR_Ajuste, 0, 0, _
                               "PAB", _
                               0, "Dias"
end if

aju_ISR_GR = ISR_Ajuste

End Function','money','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '213D36BC-452A-444D-9814-F826136D52B4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('213D36BC-452A-444D-9814-F826136D52B4','aju_OtrosDescuentos','Procesa otros descuentos asociados a la planilla de ajustes','Function aju_OtrosDescuentos()

liquido = Factores("aju_SalarioBruto").Value - _
          Factores("SeguroSocial_aju").Value - _
          Factores("SegEducativo_aju").Value - _
          Factores("aju_ISR").Value - _
          Factores("aju_ISR_GR").Value


sum = 0
valor = 0 

if Emp_OtrosDescuentos.RecordCount > 0 then
   Emp_OtrosDescuentos.MoveFirst
   do until Emp_OtrosDescuentos.EOF
      valor = round(Emp_OtrosDescuentos.Fields("ods_valor_a_descontar").Value, 2)
      if valor > liquido then
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 0
         
      else
         liquido = liquido - valor
         sum = sum + valor
         Emp_OtrosDescuentos.Fields("ods_aplicado_planilla").Value = 1
         agrega_descuentos_historial Agrupadores, _
                                     DescuentosEstaPlanilla, _
                                     Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ods_codtdc").Value, _
                                     valor, _
                                     0, 0, _
                                     Emp_OtrosDescuentos.Fields("ods_codmon").Value, _
                                     0, "Dias"
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if
aju_OtrosDescuentos = sum

End Function','money','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '74A11C69-2905-4645-9CA6-225EF691E0D3' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('74A11C69-2905-4645-9CA6-225EF691E0D3','aju_SalarioNeto','Salario neto a pagar al empleado en planilla de ajustes','Function aju_SalarioNeto()

liquido = Factores("aju_SalarioBruto").Value - _
          	Factores("aju_ISR").Value - _
          	Factores("aju_ISR_GR").Value - _
          	Factores("SegEducativo_aju").Value - _
          	Factores("SeguroSocial_aju").Value - _
          	Factores("aju_OtrosDescuentos").Value

aju_SalarioNeto = liquido

End Function
','money','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '7D1AF3D1-70A8-4168-8C97-E62AEFBA44B2' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('7D1AF3D1-70A8-4168-8C97-E62AEFBA44B2','OtrosIngresos_aju','Otros ingresos','Function OtrosIngresos_aju()
valorTotal = 0

if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      valor = round(cdbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)

	  Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   Emp_OtrosIngresos.Fields("oin_codtig").Value, _
                                   valor, _
                                   Emp_OtrosIngresos.Fields("oin_codmon").Value, _
                                   0, _
                                   "Dias"
      valorTotal = valorTotal + valor

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos_aju = valorTotal
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '1168CFE1-DEB7-4635-AC83-98B929C65E25' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1168CFE1-DEB7-4635-AC83-98B929C65E25','SSBaseCalculo_aju','Base para cálculo de Seguro Social','Function SSBaseCalculo_aju()
   SSBaseCalculo_aju = Agrupadores("BaseCalculoSeguroSocial").Value
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '52B98440-8B49-4F68-82D8-5A759D306FFD' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('52B98440-8B49-4F68-82D8-5A759D306FFD','ISRBaseCalculoGRep_aju','Base cálculo para cálculo de renta del gasto de representación','Function ISRBaseCalculoGRep_aju()

base = 0

base = Agrupadores("IngresosRentaGRepPTY").Value 

if base < 0 then
   base = 0
end if

ISRBaseCalculoGRep_aju = base

End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'C2EB06BF-4002-4628-8E86-5B1C88CC0F6D' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('C2EB06BF-4002-4628-8E86-5B1C88CC0F6D','ISRBaseCalculo_aju','Base para cálculo de renta del salario','Function ISRBaseCalculo_aju()

base = 0

base = Agrupadores("IngresosRentaPTY").Value

if base < 0 then
   base = 0
end if

ISRBaseCalculo_aju = base

End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '0C62DA23-33DF-457D-A7E2-49C0DE23F86F' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0C62DA23-33DF-457D-A7E2-49C0DE23F86F','SeguroSocial_aju','Cálculo del descuento del Seguro Social','Function SeguroSocial_aju()

cuota = 0
patronal = 0
   

if Factores("SSBaseCalculo_aju").Value >= 0.01 then
      por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
      pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)

   
   cuota = (por_cuota / 100) * Factores("SSBaseCalculo_aju").Value
   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * Factores("SSBaseCalculo_aju").Value
   if patronal < 0 then patronal = 0
end if
patronal = round(patronal + 0.00000001, 2)
cuota = round(cuota + 0.00000001, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_aju").CodTipoDescuento) and cuota > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_aju").CodTipoDescuento, _
                               cuota, patronal, Factores("SSBaseCalculo_aju").Value, _
                               "PAB", _
                               0, _
                               "Dias"
end if

SeguroSocial_aju = cuota

End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'D0EE2447-A9ED-40B9-AD16-B2FA76F70C5D' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('D0EE2447-A9ED-40B9-AD16-B2FA76F70C5D','SegEducativoBase_aju','Base para cálculo de Seguro Educativo','Function SegEducativoBase_aju()
SegEducativoBase_aju = Agrupadores("BaseCalculoSeguroEducativo").Value
End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '8715BE23-2AD6-41AA-836C-E015C4BF9F71' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8715BE23-2AD6-41AA-836C-E015C4BF9F71','SegEducativo_aju','Cálculo del descuento del Seguro Educativo','Function SegEducativo_aju()

cuota = 0
patronal = 0

base = cdbl(Factores("SegEducativoBase_aju").Value)


if base >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("pge_seg_educativo_por_desc").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("pge_seg_educativo_por_pat").Value)
   
   cuota = round(base * por_cuota / 100.0 + 0.00001,2)
   if cuota < 0 then cuota = 0
 
   patronal = round(base * pat_cuota / 100.0 + 0.00001 , 4)
   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota+ 0.000000001, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo_aju").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo_aju").CodTipoDescuento, _
                               cuota, patronal, base , _
                               "PAB", _
                               0, "Dias"
end if

SegEducativo_aju = cuota

End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'B023400F-182F-4905-848E-1529A8266869' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('B023400F-182F-4905-848E-1529A8266869','Extraordinario_aju','Horas extras','Function Extraordinario_aju()
valor = 0
total = 0
horas = 0

if not Emp_HorasExtras.EOF then
   do until Emp_HorasExtras.EOF
      valor = round(cdbl(Emp_HorasExtras.Fields("ext_valor_a_pagar").Value), 2)
      horas = cdbl(Emp_HorasExtras.Fields("ext_num_horas").Value) 
      agrega_ingresos_historial Agrupadores, _
                                IngresosEstaPlanilla, _
                                Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                                Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                Emp_HorasExtras.Fields("the_codtig").Value, _
                                valor, _
                                Emp_HorasExtras.Fields("ext_codmon").Value, _
                                horas, _
                                "Horas"
      total = total + valor
      Emp_HorasExtras.MoveNext
   loop
end if

Extraordinario_aju = total
End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:29 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'd01c3419-19d4-4852-ae64-ffd7371186cf' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d01c3419-19d4-4852-ae64-ffd7371186cf','aju_SalarioBruto','Salario Bruto','Function aju_SalarioBruto()
aju_SalarioBruto = Factores("OtrosIngresos_aju").Value + _
               Factores("Extraordinario_aju").Value

End Function','double','pa',0);

insert into [sal].[ftp_formulacion_tipos_planilla] ([ftp_codtpl],[ftp_prefijo],[ftp_table_name],[ftp_codfac_filtro],[ftp_codfcu_loop],[ftp_sp_inicializacion],[ftp_sp_finalizacion],[ftp_sp_autorizacion]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'aju','pa.aju_ajustes','7217DB5E-140E-436F-BC30-A21EEB5098B8',(select fcu_codigo from (select RowNum = row_number() OVER ( order by fcu_codigo ), fcu_codigo from sal.fcu_formulacion_cursores where fcu_codpai = 'pa' and fcu_proceso = 'Planilla') tcr where tcr.RowNum = 42),'pa.GenPla_Inicializacion','pa.GenPla_Finalizacion','pa.aupla_Autoriza_planilla');
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'7217DB5E-140E-436F-BC30-A21EEB5098B8',1,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'D08AF6E4-0DA0-48A5-A46A-7917F2C90C5D',10,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'ISR_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'5CBE3135-6C4A-46AC-8927-FCACE58FAD04',12,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'ISRGR_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'213D36BC-452A-444D-9814-F826136D52B4',13,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'74A11C69-2905-4645-9CA6-225EF691E0D3',14,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'7D1AF3D1-70A8-4168-8C97-E62AEFBA44B2',2,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'1168CFE1-DEB7-4635-AC83-98B929C65E25',5,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'52B98440-8B49-4F68-82D8-5A759D306FFD',11,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'C2EB06BF-4002-4628-8E86-5B1C88CC0F6D',9,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'0C62DA23-33DF-457D-A7E2-49C0DE23F86F',6,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'Seg Soc_PA'),(select top 1 trs_codigo from sal.trs_tipos_reserva where trs_abreviatura = 'PROV_INDEM_PA'),1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'D0EE2447-A9ED-40B9-AD16-B2FA76F70C5D',7,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'8715BE23-2AD6-41AA-836C-E015C4BF9F71',8,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'Seg Educ_PA'),(select top 1 trs_codigo from sal.trs_tipos_reserva where trs_abreviatura = 'PROV_Prima_Anti_PA'),1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'B023400F-182F-4905-848E-1529A8266869',3,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Intermedia' and tpl_codmon='PAB'),'d01c3419-19d4-4852-ae64-ffd7371186cf',4,NULL,NULL,NULL,1);

commit transaction;
