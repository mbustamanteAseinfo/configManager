/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

begin transaction

delete from [sal].[fat_factores_tipo_planilla] where [fat_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB');
delete from [sal].[ftp_formulacion_tipos_planilla] where [ftp_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB');


/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '2546c770-9e24-437a-90dd-236d44a5c706' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('2546c770-9e24-437a-90dd-236d44a5c706','EmpleadoParticipa_v','Determina si el empleado participa del calculo de esta planilla','Function EmpleadoParticipa_v()
b = Emp_InfoSalario_Vacaciones.Fields("emp_fecha_ingreso").Value <= Pla_Periodo.Fields("PPL_FECHA_FIN").Value _ 
     and Emp_InfoSalario.Fields("emp_estado").Value = "A" _
     and Emp_InfoSalario_Vacaciones.Fields("dpl_suspendido").Value = "N"

if not MontosPagoVacacion.EOF then
   b = b and True
else
   b = False
end if

EmpleadoParticipa_v = b

End Function','boolean','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'ea4d0a07-d399-45b0-bfb7-f07ef5f8c8be' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ea4d0a07-d399-45b0-bfb7-f07ef5f8c8be','DiasQuincena_v','Cantidad de días del período para el empleado','Function DiasQuincena_v()

DiasQuincena_v = 15

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '6c388dd7-fcea-46cf-904b-a8f7734e44c4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6c388dd7-fcea-46cf-904b-a8f7734e44c4','DiasTrabajados_v','Almacena la cantidad de días trabajados por el empleado en el período','Function DiasTrabajados_v()

DiasTrabajados_v = 0

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '610ea80b-7768-4853-94ce-31ce32abb8ee' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('610ea80b-7768-4853-94ce-31ce32abb8ee','SalarioActual_v','Salario Actual','Function SalarioActual_v()

SalarioActual_v = 0.00

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '8ccb605d-b740-45b3-8b0b-eb669004b406' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8ccb605d-b740-45b3-8b0b-eb669004b406','SueldoQuincenal_v','Salario de la Quincena','Function SueldoQuincenal_v()

Salario = 0
Vacacion = 0
S = 0
dv = 0
hrsVacacion = 0

MontosPagoVacacion.Filter = "mpv_tipo_ingreso=''S'' and mpv_codemp=" & CStr( Emp_InfoSalario.Fields("emp_codigo").Value )

'' Recupera los valores de pago de vacaciones
if not MontosPagoVacacion.EOF then
   Salario = CDbl(MontosPagoVacacion.Fields("mpv_salario").Value)
   ''Vacacion = CDbl(MontosPagoVacacion.Fields("mpv_promedio").Value)

   '' Busca el monto mayor de entre los 2 anteriormente calculados
   
   ''if Vacacion > Salario then
   ''   S = Vacacion
   ''else
   ''   S = Salario
   ''end if
   
   dv = CInt(MontosPagoVacacion.Fields("mpv_dias").Value)
   Factores("DiasTrabajados_v").Value = dv
   Factores("DiasQuincena_v").Value = dv
   
   ''S = (S/30.00) * dv
   S = CDbl(MontosPagoVacacion.Fields("mpv_pagado").Value)
   
   ''MontosPagoVacacion.Fields("mpv_pagado").Value = S
   ''MontosPagoVacacion.Fields("mpv_promedio").Value = Vacacion / 30.00 * dv
   ''MontosPagoVacacion.Fields("mpv_salario").Value = Salario / 30.00 * dv
end if

Factores("SalarioActual_v").Value = Salario

''if Emp_InfoSalario.Fields("emp_codigo").Value = 3 then
''   msgbox "S: " & cstr(S) & vbCrLf & _
''          "Salario: " & cstr(Salario) & vbCrLf & _
''          "Vacacion: " & cstr(Vacacion) & vbCrLf & _
''          "salarioVacacion: " & cstr(salarioVacacion) & vbCrLf & _
''          "hrsVacacion: " & cstr(hrsVacacion) & vbCrLf & _
''          "salario x hora: " & cstr(Emp_InfoSalario.Fields("emp_salario_hora").Value)
''end if

'' Graba en los historiales de ingresos los resultados
if not isnull(Factores("SueldoQuincenal_v").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SueldoQuincenal_v").CodTipoIngreso, _
                             S, "PAB", dv, "Dias"
end if

SueldoQuincenal_v = S
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '979e2f29-5185-4ce8-af52-f90ae5a5bbaa' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('979e2f29-5185-4ce8-af52-f90ae5a5bbaa','GastoRepresentacion_v','Valor de Gastos de Representacion','Function GastoRepresentacion_v()

Salario = 0
Vacacion = 0
S = 0
dv = 0
hrsVacacion = 0

MontosPagoVacacion.Filter = "mpv_tipo_ingreso=''G'' and mpv_codemp=" & CStr( Emp_InfoSalario.Fields("emp_codigo").Value )

'' Recupera los valores de pago de vacaciones
if not MontosPagoVacacion.EOF then
   Salario = CDbl(MontosPagoVacacion.Fields("mpv_salario").Value)
   ''Vacacion = CDbl(MontosPagoVacacion.Fields("mpv_promedio").Value)

   '' Busca el monto mayor de entre los 2 anteriormente calculados
   
   ''if Vacacion > Salario then
   ''   S = Vacacion
   ''else
   ''   S = Salario
   ''end if
   
   dv = CInt(MontosPagoVacacion.Fields("mpv_dias").Value)
   
   ''S = (S/30.00) * dv
   S = CDbl(MontosPagoVacacion.Fields("mpv_pagado").Value)
   
   ''MontosPagoVacacion.Fields("mpv_pagado").Value = S
   ''MontosPagoVacacion.Fields("mpv_promedio").Value = Vacacion / 30.00 * dv
   ''MontosPagoVacacion.Fields("mpv_salario").Value = Salario / 30.00 * dv
end if

''if Emp_InfoSalario.Fields("emp_codigo").Value = 3 then
''   msgbox "S: " & cstr(S) & vbCrLf & _
''          "Salario: " & cstr(Salario) & vbCrLf & _
''          "Vacacion: " & cstr(Vacacion) & vbCrLf & _
''          "salarioVacacion: " & cstr(salarioVacacion) & vbCrLf & _
''          "hrsVacacion: " & cstr(hrsVacacion) & vbCrLf & _
''          "salario x hora: " & cstr(Emp_InfoSalario.Fields("emp_salario_hora").Value)
''end if

'' Graba en los historiales de ingresos los resultados
if not isnull(Factores("GastoRepresentacion_v").CodTipoIngreso) and S > 0 then
   agrega_ingresos_historial Agrupadores, _
                             IngresosEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("GastoRepresentacion_v").CodTipoIngreso, _
                             S, "PAB", dv, "Dias"
end if

GastoRepresentacion_v = S
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '113a5429-05e5-4492-b046-a8efccf4866b' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('113a5429-05e5-4492-b046-a8efccf4866b','OtrosIngresos_v','Otros Ingresos','Function OtrosIngresos_v()

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

OtrosIngresos_v = o

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'ee0880a3-a8f6-4709-a3ab-4976e54ecbaf' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ee0880a3-a8f6-4709-a3ab-4976e54ecbaf','SalarioBruto_v','Cálculo del Salario Bruto','Function SalarioBruto_v()
var_SalarioBruto = 0.00

var_SalarioBruto = Factores("SueldoQuincenal_v").Value + _
                   Factores("GastoRepresentacion_v").Value + _                   
                   Factores("OtrosIngresos_v").Value

if var_SalarioBruto < 0 then
   var_SalarioBruto = 0.00
end if

SalarioBruto_v = var_SalarioBruto
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '9107bb74-d1e7-4dee-b8dd-eb6c5061963f' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9107bb74-d1e7-4dee-b8dd-eb6c5061963f','SSBaseCalculo_v','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo_v()

SSBaseCalculo_v = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'bd1aad4d-73f9-4a2d-87af-4f785ce10312' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('bd1aad4d-73f9-4a2d-87af-4f785ce10312','SeguroSocialPatrono_v','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono_v()
SeguroSocialPatrono_v = 0.00
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '4e81387b-73f1-455e-8577-0ad288ea090d' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('4e81387b-73f1-455e-8577-0ad288ea090d','SeguroSocial_v','Cálculo del descuento del Seguro Social','Function SeguroSocial_v()

patAnterior = 0
afectoAnterior = 0
descAnterior = 0
patEspecial = 0

base = 0
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_social").Value = "N" then
   SeguroSocial = cuota
   Exit Function
end if
   
if Factores("SSBaseCalculo_v").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat").Value)
   
   base = CDbl(Factores("SSBaseCalculo_v").Value)

   cuota = (por_cuota / 100) * base

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * base

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_v").CodTipoDescuento) and cuota > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_v").CodTipoDescuento, _
                               cuota, patronal, base, _
                               "PAB", 0, ""
end if

Factores("SeguroSocialPatrono_v").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_v").CodTipoReserva) and patronal then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_v").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if

SeguroSocial_v = cuota

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '1be95969-50e8-4dab-8d45-b1056eede314' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1be95969-50e8-4dab-8d45-b1056eede314','SegEducativoBase_v','Base para calculo de Seguro Educativo','Function SegEducativoBase_v()

SegEducativoBase_v = Agrupadores("BaseCalculoSeguroEducativo").Value 

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '8b29cd99-cc00-4177-8cde-694527f86554' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8b29cd99-cc00-4177-8cde-694527f86554','SegEducativoPatronal_v','Parte Patronal del Seguro Educativo','Function SegEducativoPatronal_v()

SegEducativoPatronal_v = 0.00

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'ff82a755-fc64-421c-a8e0-8a3d722861d4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ff82a755-fc64-421c-a8e0-8a3d722861d4','SegEducativo_v','Valor del Descuento de Seguro Educativo','Function SegEducativo_v()
patAnterior = 0
afectoAnterior = 0
descAnterior = 0   

base = 0
cuota = 0
patronal = 0

if Emp_InfoSalario.Fields("dpl_seguro_educativo").Value = "N" then
   SegEducativo_v = cuota
   Exit Function
end if

if Factores("SegEducativoBase_v").Value >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_DESC").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("PGE_SEG_EDUCATIVO_POR_PAT").Value)
   
   base = cDbl(Factores("SegEducativoBase_v").Value)
   cuota = round(por_cuota / 100.0 * base, 4)

   if cuota < 0 then cuota = 0
 
   patronal = round(pat_cuota / 100.0 * base, 4)

   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo_v").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo_v").CodTipoDescuento, _
                               cuota, patronal, base, _
                               "PAB", 0, ""
end if

Factores("SegEducativoPatronal_v").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro educativo
if not isnull(Factores("SegEducativoPatronal_v").CodTipoReserva) and patronal > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SegEducativoPatronal_v").CodTipoReserva, _
                             patronal, "PAB", 0 , ""
end if

SegEducativo_v = cuota

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '48c4597a-bc15-414d-b312-80ede54a79e9' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('48c4597a-bc15-414d-b312-80ede54a79e9','ISRBaseCalculo_v','Base para calculo de renta','Function ISRBaseCalculo_v()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0.00

base = Agrupadores("IngresosRentaPTY").Value

if base < 0 then
   base = 0.00
end if

ISRBaseCalculo_v = base
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '6a5ea415-9181-47a9-969c-12a5cf9169a4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6a5ea415-9181-47a9-969c-12a5cf9169a4','ISRBaseCalculoGRep_v','Base para calculo de renta para gastos de representacion','Function ISRBaseCalculoGRep_v()
'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0.00

base = Agrupadores("IngresosRentaGRepPTY").Value

if base < 0.00 then
   base = 0.00
end if

ISRBaseCalculoGRep_v = base
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'f461c66c-e739-45a6-8da9-8d78294d0301' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f461c66c-e739-45a6-8da9-8d78294d0301','DevolucionDescRenta_v','Devolucion por Descuento de Renta','Function DevolucionDescRenta_v()
DevolucionDescRenta_v = 0.00
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '5756f168-f8b2-4638-8075-ca7149f5e78c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('5756f168-f8b2-4638-8075-ca7149f5e78c','CreditoISRGastoRep_v','Valor del Descuento por Gasto de Representacion','Function CreditoISRGastoRep_v()
CreditoISRGastoRep_v = 0.00
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'a8748a9f-b066-4224-99c4-5305531e724e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('a8748a9f-b066-4224-99c4-5305531e724e','ISR_v','Descuento de Impuesto sobre la Renta','Function ISR_v()
''RENTA PLANILLA QUINCENAL
ingreso_planilla = CDbl(Factores("ISRBaseCalculo_v").Value)
Datos_Renta.Fields("RAP_INGRESO_PLANILLA").Value = ingreso_planilla

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario_Vacaciones.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculo_v").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF then
  ISR_v = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00
retenido = 0.00

dias = 0
dias = Factores("DiasTrabajados_v").Value

continuar = 1

if not ISR_Salario.EOF and not ISR_Salario.BOF then
  salario_quincenal = CDbl(ISR_Salario.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value) * dias / 15
    else
       valor = CDbl(ISR_Salario.Fields("isr_quincenal").Value) * ingreso_planilla / salario_quincenal
       continuar = 0
    end if
  end if
  
  acumulado = CDbl(ISR_Salario.Fields("rap_acumulado").Value)
  proyectado = CDbl(ISR_Salario.Fields("rap_proyectado").Value)
  desc_legal = CDbl(ISR_Salario.Fields("rap_desc_legal").Value)
  isr_anual = CDbl(ISR_Salario.Fields("isr_anual").Value)
  retenido = CDbl(ISR_Salario.Fields("rap_retenido").Value)
  
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
    
    if isr_anual_planilla > isr_anual and isr_anual_planilla > retenido then
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
   Datos_Renta.Fields("rap_a_descontar").Value = valor
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Vacaciones.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_v").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR_v = valor

End Function
','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '9351d3c2-6d78-49f1-9c8f-571fbaf75a3c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('9351d3c2-6d78-49f1-9c8f-571fbaf75a3c','ISR_GASTO_REP_v','Factor encargado de calcular el impuesto sobre la renta aplicado al Gasto de Representación','Function ISR_GASTO_REP_v()
''RENTA PLANILLA QUINCENAL

''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario_Vacaciones.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculoGRep_v").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
  ISR_GASTO_REP_v = valor
  Exit Function
end if

acumulado = 0.00
proyectado = 0.00
desc_legal = 0.00
ingreso_anual_planilla = 0.00
isr_anual = 0.00
isr_anual_planilla = 0.00
salario_quincenal = 0.00

dias = 0
dias = Factores("DiasTrabajados_v").Value

continuar = 1

ingreso_planilla = CDbl(Factores("ISR_GASTO_REP_v").Value)
Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = ingreso_planilla

if not ISR_GastoRep.EOF and not ISR_GastoRep.BOF then
  salario_quincenal = CDbl(ISR_GastoRep.Fields("salario_quincenal").Value)
  if ingreso_planilla = salario_quincenal then
    valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value)
    continuar = 0
  else
    if ingreso_planilla > salario_quincenal then
      valor = CDbl(ISR_GastoRep.Fields("isr_quincenal").Value) * dias / 15
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
                               Emp_InfoSalario_Vacaciones.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP_v").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
end if

ISR_GASTO_REP_v = valor

End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'e0dc35bb-f005-454d-826b-33048b6ddb2f' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('e0dc35bb-f005-454d-826b-33048b6ddb2f','OtrosDescuentos_v','Procesa Otros Descuentos asociados al periodo de pago','Function OtrosDescuentos_v()
liquido = Factores("SalarioBruto_v").Value - _
          Factores("SeguroSocial_v").Value - _
          Factores("SegEducativo_v").Value - _
          Factores("ISR_v").Value - _
          Factores("ISR_GASTO_REP_v").Value
   
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

OtrosDescuentos_v = sum
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = 'ca0fc64b-7958-4c29-8e66-3b7862059945' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ca0fc64b-7958-4c29-8e66-3b7862059945','DescCiclicos_v','Detalle de Descuentos Cíclicos para Vacaciones','Function DescCiclicos_v()

liquido = Factores("SalarioBruto_v").Value - _
          Factores("SeguroSocial_v").Value - _
          Factores("SegEducativo_v").Value - _
          Factores("ISR_v").Value - _
          Factores("ISR_GASTO_REP_v").Value - _
          Factores("OtrosDescuentos_v").Value
   
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
            CuotasDescuentosCiclicos.Fields("cdc_aplicado_planilla").Value = 0            
        End If

   CuotasDescuentosCiclicos.MoveNext
 Loop
else
   dc=0.00
end if

DescCiclicos_v = dc
End Function','double','pa',0);

/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:11 PM */

delete from [sal].[fac_factores] where [fac_codigo] = '9b5cea25-b38d-4e75-9af0-a5a4c0499a50' and fac_codpai = 'pa';

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


insert into [sal].[ftp_formulacion_tipos_planilla] ([ftp_codtpl],[ftp_prefijo],[ftp_table_name],[ftp_codfac_filtro],[ftp_codfcu_loop],[ftp_sp_inicializacion],[ftp_sp_finalizacion],[ftp_sp_autorizacion]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'vac','pa.vac_vacacion','2546c770-9e24-437a-90dd-236d44a5c706',(select fcu_codigo from (select RowNum = row_number() OVER ( order by fcu_codigo ), fcu_codigo from sal.fcu_formulacion_cursores where fcu_codpai = 'pa' and fcu_proceso = 'Planilla') tcr where tcr.RowNum = 35),'pa.GenPla_Inicializacion_vac','pa.GenPla_Finalizacion','pa.aupla_autoriza_planilla_vac');
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'2546c770-9e24-437a-90dd-236d44a5c706',1,NULL,NULL,NULL,0);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'ea4d0a07-d399-45b0-bfb7-f07ef5f8c8be',2,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'6c388dd7-fcea-46cf-904b-a8f7734e44c4',3,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'610ea80b-7768-4853-94ce-31ce32abb8ee',4,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'8ccb605d-b740-45b3-8b0b-eb669004b406',5,5,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'979e2f29-5185-4ce8-af52-f90ae5a5bbaa',6,6,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'113a5429-05e5-4492-b046-a8efccf4866b',7,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'ee0880a3-a8f6-4709-a3ab-4976e54ecbaf',8,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'9107bb74-d1e7-4dee-b8dd-eb6c5061963f',9,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'bd1aad4d-73f9-4a2d-87af-4f785ce10312',10,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'4e81387b-73f1-455e-8577-0ad288ea090d',11,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'Seg Soc_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'1be95969-50e8-4dab-8d45-b1056eede314',12,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'8b29cd99-cc00-4177-8cde-694527f86554',13,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'ff82a755-fc64-421c-a8e0-8a3d722861d4',14,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'Seg Educ_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'48c4597a-bc15-414d-b312-80ede54a79e9',15,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'6a5ea415-9181-47a9-969c-12a5cf9169a4',16,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'f461c66c-e739-45a6-8da9-8d78294d0301',17,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'5756f168-f8b2-4638-8075-ca7149f5e78c',18,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'a8748a9f-b066-4224-99c4-5305531e724e',19,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'ISR_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'9351d3c2-6d78-49f1-9c8f-571fbaf75a3c',20,NULL,(select top 1 tdc_codigo from sal.tdc_tipos_descuento where tdc_abreviatura = 'ISRGR_PA'),NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'e0dc35bb-f005-454d-826b-33048b6ddb2f',21,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'ca0fc64b-7958-4c29-8e66-3b7862059945',22,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Vacaciones' and tpl_codmon='PAB'),'9b5cea25-b38d-4e75-9af0-a5a4c0499a50',23,NULL,NULL,NULL,1);



commit transaction;
