begin transaction

delete from [sal].[fat_factores_tipo_planilla] where [fat_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB');
delete from [sal].[ftp_formulacion_tipos_planilla] where [ftp_codtpl] = (select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB');



delete from [sal].[fac_factores] where [fac_codigo] = '1a6f3ab6-13a3-47a4-96d5-16a695850a05' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1a6f3ab6-13a3-47a4-96d5-16a695850a05','EmpleadoParticipa_d','Determina si el empleado participa del calculo de esta planilla','Function EmpleadoParticipa_d()

b = Emp_InfoSalario.Fields("EMP_FECHA_INGRESO").Value <= Pla_Periodo.Fields("PPL_FECHA_FIN").Value _ 
    and Emp_InfoSalario.Fields("dpl_suspendido").Value = "N" AND Emp_InfoSalario.Fields("emp_estado").Value = "A"

EmpleadoParticipa_d = b


End Function','boolean','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'c2da53a4-827e-4fbf-bb42-6c075bd9e2bc' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('c2da53a4-827e-4fbf-bb42-6c075bd9e2bc','DiasQuincena_d','Cantidad de días del período para el empleado','Function DiasQuincena_d()

DiasQuincena_d = 120

End Function','double','pa',0);

delete from [sal].[fac_factores] where [fac_codigo] = '3d8f0d05-5f7c-4783-8f26-e8516fcf7202' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3d8f0d05-5f7c-4783-8f26-e8516fcf7202','DiasTrabajados_d','Almacena la cantidad de días trabajados por el empleado en el período','Function DiasTrabajados_d()

DiasTrabajados_d = 0

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'f44f064e-c4e1-48b0-bd59-2da1848a6d30' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f44f064e-c4e1-48b0-bd59-2da1848a6d30','DescAnticipoXIII_GR','Aplica el descuento por el anticipo del XIII de GR que haya sido pagado en el período de la planilla','Function DescAnticipoXIII_GR()

DescAnticipoXIII_GR = 0.00

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '005636ba-b9c4-4f2a-b41b-bca88c984435' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('005636ba-b9c4-4f2a-b41b-bca88c984435','DescAnticipoXIII','Aplica el descuento por el anticipo del XIII que haya sido pagado en el período de la planilla','Function DescAnticipoXIII()

anticipoXIII = 0.00
anticipoXIII_GR = 0.00

if not AnticipoXIII_Pagado.EOF then
   anticipoXIII = AnticipoXIII_Pagado.Fields("ADELANTO_XIII").Value
   anticipoXIII_GR = AnticipoXIII_Pagado.Fields("ADELANTO_XIII_GR").Value
   
   Factores("DescAnticipoXIII_GR").Value = anticipoXIII_GR
end if

DescAnticipoXIII = anticipoXIII

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'b7ecbdb0-a784-44fc-b2df-d78a39ac538a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('b7ecbdb0-a784-44fc-b2df-d78a39ac538a','Decimo_Tercero_GRep','Factor que Calcula el Valor del Decimo Tercer Mes del Gasto de Representacion.','Function Decimo_Tercero_GRep()

Decimo_Tercero_GRep = 0.00

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'a2274c4d-3258-439a-b961-048614b51277' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('a2274c4d-3258-439a-b961-048614b51277','DecimoTercero','Calcula el monto del pago del Decimo Tercero','Function DecimoTercero()

bonoSalario = 0.00
diasSalario = 0.00
anticipoXIII = 0.00
anticipoXIII_GR = 0.00

anticipoXIII = Factores("DescAnticipoXIII").Value
anticipoXIII_GR = Factores("DescAnticipoXIII_GR").Value

'' Decimo Tercero correspondiente al salario
if not PromedioSalarioXIII.EOF then
   bonoSalario = round(PromedioSalarioXIII.Fields("PROMEDIO_SALARIO").Value, 2)
   diasSalario = round(PromedioSalarioXIII.Fields("INN_DIAS_SALARIO").Value, 2)
   bonoSalario = bonoSalario / 120.00 * diasSalario
   
   ''bonoSalario = bonoSalario - anticipoXIII
   
   if bonoSalario < 0.00 then
      bonoSalario = 0.00
   end if
end if

if bonoSalario > 0 then
   agrega_ingresos_historial Agrupadores, _  
         IngresosEstaPlanilla, _
         Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
         Pla_Periodo.Fields("PPL_CODPPL").Value, _
         Factores("DecimoTercero").CodTipoIngreso, _
         bonoSalario, "PAB", diasSalario, "Dias"
end if

'' Asigna los dias trabajados asociados al Decimo Tercero
Factores("DiasTrabajados_d").Value = diasSalario

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Decimo Tercero correspondiente a los gastos de representacion
if not PromedioSalarioXIII.EOF then
   bonoGRep = round(PromedioSalarioXIII.Fields("PROMEDIO_GREP").Value, 2)
   diasGRep = round(PromedioSalarioXIII.Fields("INN_DIAS_GREP").Value, 2)
   bonoGRep = bonoGRep / 120.00 * diasGRep
   
   ''bonoGRep = bonoGRep - anticipoXIII_GR
   
   if bonoGRep < 0.00 then
      bonoGRep = 0.00
   end if
end if

if bonoGRep > 0 then
   agrega_ingresos_historial Agrupadores, _  
          IngresosEstaPlanilla, _
          Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
          Pla_Periodo.Fields("PPL_CODPPL").Value, _
          Factores("Decimo_Tercero_GRep").CodTipoIngreso, _
          bonoGRep, "PAB", diasGRep, "Dias"
end if

Factores("Decimo_Tercero_GRep").Value = bonoGRep

DecimoTercero = bonoSalario

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '39db6b8c-ff50-46d2-92c3-2ae5423f5bca' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('39db6b8c-ff50-46d2-92c3-2ae5423f5bca','OtrosIngresos_d','Otros ingresos registrados para el pago de la planilla','Function OtrosIngresos_d()

o = 0.00
   
if Emp_OtrosIngresos.RecordCount > 0 then
   Emp_OtrosIngresos.MoveFirst
   do until Emp_OtrosIngresos.EOF
    
      vc = round(CDbl(Emp_OtrosIngresos.Fields("oin_valor_a_pagar").Value), 2)
      
      Emp_OtrosIngresos.Fields("oin_aplicado_planilla").Value = 1

      agrega_ingresos_historial Agrupadores, _
                                   IngresosEstaPlanilla, _
                                   Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                   Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                   cint(Emp_OtrosIngresos.Fields("OIN_CODTIG").Value), _
                                   vc, cstr(Emp_OtrosIngresos.Fields("oin_codmon").Value), 0, "Dias" 
      o = o + vc

      Emp_OtrosIngresos.MoveNext
   loop
end if

OtrosIngresos_d = o

End Function','double','pa',0);



delete from [sal].[fac_factores] where [fac_codigo] = 'b9bd0f33-6d74-438e-a000-b3c615c1ef90' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('b9bd0f33-6d74-438e-a000-b3c615c1ef90','DescExcesoXIII_GR','Descuento por Exceso XIII pendiente por aplicar del gasto de representación','Function DescExcesoXIII_GR()

DescExcesoXIII_GR = 0.00

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'f7b1bd19-2697-4d79-a121-d1b43fffe130' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f7b1bd19-2697-4d79-a121-d1b43fffe130','DescExcesoXIII','Descuento por Exceso XIII pendiente por aplicar','Function DescExcesoXIII()
Decimo = 0.00
DecimoGr = 0.00

Exceso = 0.00
ExcesoGr = 0.00

''Decimo = CDbl(Factores("DecimoTercero").Value)
Decimo = Agrupadores("XIIIMes").Value
if Decimo > 0 then
   if not ExcesoXIII.EOF then
      Exceso = CDbl(ExcesoXIII.Fields("EXCESO").Value)
      if Exceso >= Decimo then
         Exceso = Decimo
      end if
   end if
end if

if Exceso > 0 then
   '' Inserta el registro en la tabla de descuentos
   if not isnull(Factores("DescExcesoXIII").CodTipoDescuento) then
      agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescExcesoXIII").CodTipoDescuento, _
                               Exceso, 0, 0, "PAB", 0, "Dias"
   end if
end if

''DecimoGr = CDbl(Factores("Decimo_Tercero_GRep").Value)
DecimoGr = Agrupadores("XIIIMesGR").Value
if DecimoGr > 0 then
   if not ExcesoXIII_GR.EOF then
      ExcesoGr = CDbl(ExcesoXIII_GR.Fields("EXCESO").Value)
      if ExcesoGr >= DecimoGr then
         ExcesoGr = DecimoGr
      end if
   end if
end if

if ExcesoGr > 0 then
   '' Inserta el registro en la tabla de descuentos
   if not isnull(Factores("DescExcesoXIII_GR").CodTipoDescuento) then
      agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescExcesoXIII_GR").CodTipoDescuento, _
                               ExcesoGr, 0, 0, "PAB", 0, "Dias"
   end if
end if

DescExcesoXIII = Exceso

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '6dc55c1a-e329-4401-b168-4f9bd221584a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6dc55c1a-e329-4401-b168-4f9bd221584a','SegSocialGR_BaseCalc','Seguro Social de Gastos de Representación','Function SegSocialGR_BaseCalc()

SegSocialGR_BaseCalc = Agrupadores("XIIIMesGR").Value ''Factores("Decimo_Tercero_GRep").Value

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '597292e5-30a0-4669-bacc-a15bf419e6f8' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('597292e5-30a0-4669-bacc-a15bf419e6f8','SSBaseCalculo_d','Representa el salario sobre el cual se calcula el descuento de Seguro Social','Function SSBaseCalculo_d()

SSBaseCalculo_d = Agrupadores("BaseCalculoSeguroSocial").Value

End Function','double','pa',0);



delete from [sal].[fac_factores] where [fac_codigo] = 'cb666c61-9488-4263-9109-97647d4435d9' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('cb666c61-9488-4263-9109-97647d4435d9','ISRBaseCalculo_d','Base para el cálculo de renta','Function ISRBaseCalculo_d()

'' Almacena en las reservas el devengado para renta segun el agrupador

base = 0

base = Agrupadores("IngresosRentaPTY").Value 

if base < 0 then
   base = 0
end if


'' Almacena en las reservas el devengado para renta segun el agrupador
if not isnull(Factores("ISRBaseCalculo_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("ISRBaseCalculo_d").CodTipoReserva, _
                             base,"PAB", 0, "" 
end if

ISRBaseCalculo_d = base

End Function','double','pa',0);



delete from [sal].[fac_factores] where [fac_codigo] = '9db7d3f0-52a2-447e-b64d-f4d4fd2c3c13' and fac_codpai = 'pa';

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



delete from [sal].[fac_factores] where [fac_codigo] = '6d957e26-744a-4259-8abf-6f60cd44b15a' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6d957e26-744a-4259-8abf-6f60cd44b15a','ISR_d','Cálculo del impuesto sobre la renta','Function ISR_d()
''Si especifica que no paga renta, no ejecuta este factor
valor = 0.00
if Emp_InfoSalario.Fields("dpl_renta").Value = "N" or Factores("ISRBaseCalculo_d").Value = 0 or Datos_Renta.EOF or Datos_Renta.BOF or Factores("DecimoTercero").Value <= 0 then
   ISR = valor
   Exit Function
end if

Neto = 0.00
Anual = 0.00
Restante = 0.00

Datos_Renta.Fields("RAP_INGRESO_PLANILLA").Value = Factores("ISRBaseCalculo_d").Value
Datos_Renta.Fields("RAP_PROYECTADO").Value = Datos_Renta.Fields("RAP_PROYECTADO").Value - Factores("ISRBaseCalculo_d").Value

''Neto = Factores("ISRBaseCalculo").Value * 1.50 + Datos_Renta.Fields("RAP_ACUMULADO").Value + Datos_Renta.Fields("RAP_PROYECTADO").Value 
Neto = Factores("ISRBaseCalculo_d").Value + Datos_Renta.Fields("RAP_ACUMULADO").Value + Datos_Renta.Fields("RAP_PROYECTADO").Value 
Neto = Neto - Datos_Renta.Fields("RAP_DESC_LEGAL").Value 

TablaISR.MoveFirst

 if not (TablaISR.EOF and TablaISR.BOF) then
    do until TablaISR.EOF
       if Neto >= TablaISR.Fields("ISR_DESDE").Value and Neto <= TablaISR.Fields("ISR_HASTA").Value then
           Anual = ((Neto - TablaISR.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR.Fields("ISR_PCT").Value /100.00)) + TablaISR.Fields("ISR_VALOR").Value 
           Restante = Anual - Datos_Renta.Fields("RAP_RETENIDO").Value 
           if Datos_Renta.Fields("RAP_PERIODOS_RESTANTES").Value = 0 then
              valor = Restante
           else
              valor = round((Restante/ (Datos_Renta.Fields("RAP_PERIODOS_RESTANTES").Value)),2) * 2.00 / 3.00
              valor = round(valor*100.00 + 0.100)/100
           end if

           if valor > 0 then
              if not RentaAdelantoXIII.EOF then
                 valor = valor - RentaAdelantoXIII.Fields("VALOR").Value
                 if valor < 0 then
                    valor = 0
                 end if
              end if
           end if

           ''if valor > Agrupadores("XIIIMes").Value then
           ''   valor = 0
           ''end if

           if not isnull(Factores("ISR_d").CodTipoDescuento) and valor > 0 then
              Datos_Renta.Fields("RAP_A_DESCONTAR").Value = valor
              
              agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_d").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, "Dias"
            end if
       end if
       TablaISR.MoveNext
    loop
 end if

ISR_d = valor
End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '15148a7e-87ac-4ab3-8288-087f367fe82c' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('15148a7e-87ac-4ab3-8288-087f367fe82c','ISR_GASTO_REP_d','Cálculo del impuesto sobre la renta sobre el gasto de representación','Function ISR_GASTO_REP_d()
valor = 0.00
''Si especifica que no paga renta, no ejecuta este factor
valor = 0
if Emp_InfoSalario.Fields("dpl_renta_gr").Value = "N" or Factores("ISRBaseCalculoGRep_d").Value = 0 or Datos_Renta_Gastos_Rep.EOF or Datos_Renta_Gastos_Rep.BOF then
   ISR_GASTO_REP_d = valor
   Exit Function
end if

Neto = 0
Anual = 0
Restante = 0

Datos_Renta_Gastos_Rep.Fields("rag_ingreso_planilla").Value = Factores("ISRBaseCalculoGRep_d").Value
''Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value = Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value - Agrupadores("IngresosRentaGRepPTY").Value

''Neto = Datos_Renta_Gastos_Rep.Fields("RAP_ACUMULADO").Value + Datos_Renta_Gastos_Rep.Fields("RAP_PROYECTADO").Value 
Neto = Factores("ISRBaseCalculoGRep_d").Value = 0 + Datos_Renta_Gastos_Rep.Fields("rag_acumulado").Value + Datos_Renta_Gastos_Rep.Fields("rag_proyectado").Value

Neto = Neto - Datos_Renta_Gastos_Rep.Fields("rag_desc_legal").Value 

TablaISR_GRep.MoveFirst

 if not (TablaISR_GRep.EOF and TablaISR_GRep.BOF) then
    do until TablaISR_GRep.EOF

       if Neto >= TablaISR_GRep.Fields("ISR_DESDE").Value and Neto <= TablaISR_GRep.Fields("ISR_HASTA").Value then
           if TablaISR_GRep.Fields("ISR_VALOR").Value <> 0 then
              Anual = ((Neto - TablaISR_GRep.Fields("ISR_EXCEDENTE").Value ) * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)) + TablaISR_GRep.Fields("ISR_VALOR").Value 
              Restante = Anual - Datos_Renta_Gastos_Rep.Fields("rag_retenido").Value 
              if Datos_Renta_Gastos_Rep.Fields("rag_periodos_restantes").Value = 0 then
                 valor = Restante
              else
                 valor = (Restante/ (Datos_Renta_Gastos_Rep.Fields("rag_periodos_restantes").Value)) * 2.00 / 3.00
              end if
           else
              valor = Factores("ISRBaseCalculoGRep_d").Value * ( TablaISR_GRep.Fields("ISR_PCT").Value /100.00)
              valor = round(valor, 2)
           end if
           
           if valor > 0 then
              if not RentaAdelantoXIIIGR.EOF then
                 valor = valor - RentaAdelantoXIIIGR.Fields("VALOR").Value
                 if valor < 0 then
                    valor = 0
                 end if
              end if
           end if

           if not isnull(Factores("ISR_GASTO_REP_d").CodTipoDescuento) and valor > 0 then
              Datos_Renta_Gastos_Rep.Fields("rag_a_descontar").Value = valor
              
              agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("ISR_GASTO_REP_d").CodTipoDescuento, _
                               valor, 0, 0, "PAB", 0, ""
            end if
       end if

    TablaISR_GRep.MoveNext
    loop
 end if

ISR_GASTO_REP_d = valor
End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '3e4ea582-1b4b-4baa-83a4-d7949d452642' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3e4ea582-1b4b-4baa-83a4-d7949d452642','SeguroSocialPatrono_d','Calculo del Seguro Social del Patrono','Function SeguroSocialPatrono_d()

SeguroSocialPatrono_d = 0

End Function','double','pa',0);

delete from [sal].[fac_factores] where [fac_codigo] = 'da82728a-120a-499b-9398-81d7ea990811' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('da82728a-120a-499b-9398-81d7ea990811','SSPatronalEspecial','Aporte patronal especial del seguro social','Function SSPatronalEspecial()

SSPatronalEspecial = 0

End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'f5949487-5943-449b-ac95-907bca42829e' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f5949487-5943-449b-ac95-907bca42829e','SeguroSocial_d','Cálculo del descuento del Seguro Social','Function SeguroSocial_d()
patAnterior = 0.00
afectoAnterior = 0.00
descAnterior = 0.00
patEspecial = 0.00
   
cuota = 0.00
patronal = 0.00

'' No calcula descuentos legales para empleados temporales
''if not Factores("tieneContratoPermane").Value then
''   SeguroSocial = 0
''   exit function
''end if
   
if Factores("SSBaseCalculo_d").Value >= 0.01 then
   por_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_decimo").Value)
   pat_cuota = cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value)
   
   '' JR (ASEINFO GT) SE COMENTO PORQUE NO SE UTILIZA POR DEFAULT
   ''pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)

   afectoAnterior = Factores("SSBaseCalculo_d").Value
      
   cuota = (por_cuota / 100) * afectoAnterior - descAnterior

   patEspecial = (pat_espec / 100) * (afectoAnterior - descAnterior)

   if cuota < 0 then cuota = 0
   
   patronal = (pat_cuota / 100) * afectoAnterior - patAnterior

   if patronal < 0 then patronal = 0
end if

cuota = round(cuota, 2)

'' Inserta el registro en la tabla de descuentos
if not isnull(Factores("SeguroSocial_d").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SeguroSocial_d").CodTipoDescuento, _
                               cuota, patronal, Agrupadores("BaseCalculoSeguroSocial").Value, "PAB", 0, ""
end if

Factores("SeguroSocialPatrono_d").Value = patronal

'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_d").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_d").CodTipoReserva, _
                             patronal, "PAB", 0, ""
end if


Factores("SSPatronalEspecial").Value = patEspecial

'' Almacena en las reservas el aporte patronal ESPECIAL de seguro social
if not isnull(Factores("SSPatronalEspecial").CodTipoReserva) then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SSPatronalEspecial").CodTipoReserva, _
                             patEspecial, "PAB", 0, ""
end if

SeguroSocial_d = cuota
End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = 'f3da6f34-74ef-4311-9002-002ab7099e02' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f3da6f34-74ef-4311-9002-002ab7099e02','SegSocGastoRep','Cuota de seguro social para los gastos de representación','Function SegSocGastoRep()
isss_gr = 0

''if 1 = 2 then
isss_gr_patronal = 0
patEspecial = 0

'' JR (ASEINFO GT) SE COMENTO ESTAS DOS INSTRUCCIONES 
'' PORQUE NO SE UTILIZAN
''pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)
''patEspecial = (pat_espec / 100) * (Factores("SegSocialGR_BaseCalc").Value)

'' Si la base del seguro social de gastos de representación es mayor que cero, calcula el descuento
if not isnull(Factores("SegSocGastoRep").CodTipoDescuento) and Factores("SegSocialGR_BaseCalc").Value > 0 then
   isss_gr = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_decimo").Value) / 100)
   isss_gr_patronal = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value) / 100)

   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegSocGastoRep").CodTipoDescuento, _
                               isss_gr, isss_gr_patronal, Factores("SegSocialGR_BaseCalc").Value , "PAB", 0,""
end if


'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_d").CodTipoReserva) and isss_gr_patronal > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_d").CodTipoReserva, _
                             isss_gr_patronal, "PAB", 0, ""
end if


'' Almacena en las reservas el aporte patronal ESPECIAL de seguro social
if not isnull(Factores("SSPatronalEspecial").CodTipoReserva) and patEspecial > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SSPatronalEspecial").CodTipoReserva, _
                             patEspecial, "PAB", 0, ""
end if

''end if
SegSocGastoRep = isss_gr
End Function','double','pa',0);


delete from [sal].[fac_factores] where [fac_codigo] = '1da69547-e0e1-450f-aea7-901248e76a99' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1da69547-e0e1-450f-aea7-901248e76a99','SegSocGRPatronal','Aporte patronal al seguro social de gastos de representación','Function SegSocGRPatronal()
isss_gr_patronal = 0.00

''if 1 = 2 then
'' Si la base del seguro social de gastos de representación es mayor que cero, calcula el descuento
if  not isnull(Factores("SegSocGRPatronal").CodTipoReserva) and (Factores("SegSocialGR_BaseCalc").Value > 0) then
   isss_gr_patronal = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value) / 100)

   if isss_gr_patronal > 0 then
      agrega_reservas_historial Agrupadores, _
                                ReservasEstaPlanilla, _
                                Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                Factores("SegSocGRPatronal").CodTipoReserva, _
                                isss_gr_patronal, "PAB", 0, ""
   end if
end if
''end if

SegSocGRPatronal = isss_gr_patronal
End Function','double','pa',0);



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


delete from [sal].[fac_factores] where [fac_codigo] = 'd9bab822-bee7-4029-98c7-eb2b96516c83' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d9bab822-bee7-4029-98c7-eb2b96516c83','OtrosDescuentos_d','Otros descuentos de planilla decimo tercero','Function OtrosDescuentos_d()
liquido = Factores("DecimoTercero").Value + _
          Factores("Decimo_Tercero_GRep").Value + _
          Factores("OtrosIngresos_d").Value
   
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
                                     Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                     Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                     Emp_OtrosDescuentos.Fields("ODS_CODTDC").Value, _
                                     valor, 0, 0, "PAB", 0, ""
      end if
      Emp_OtrosDescuentos.MoveNext
   loop
end if
   
OtrosDescuentos_d = sum
End Function','double','pa',0);


insert into [sal].[ftp_formulacion_tipos_planilla] ([ftp_codtpl],[ftp_prefijo],[ftp_table_name],[ftp_codfac_filtro],[ftp_codfcu_loop],[ftp_sp_inicializacion],[ftp_sp_finalizacion],[ftp_sp_autorizacion]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'ter','pa.ter_decimo','1a6f3ab6-13a3-47a4-96d5-16a695850a05',(select fcu_codigo from (select RowNum = row_number() OVER ( order by fcu_codigo ), fcu_codigo from sal.fcu_formulacion_cursores where fcu_codpai = 'pa' and fcu_proceso = 'Planilla') tcr where tcr.RowNum = 12),'pa.GenPla_Inicializacion_XIII','pa.GenPla_Finalizacion_XIII','pa.aupla_autoriza_planilla');
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'1a6f3ab6-13a3-47a4-96d5-16a695850a05',1,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'c2da53a4-827e-4fbf-bb42-6c075bd9e2bc',2,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'3d8f0d05-5f7c-4783-8f26-e8516fcf7202',3,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'f44f064e-c4e1-48b0-bd59-2da1848a6d30',4,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'005636ba-b9c4-4f2a-b41b-bca88c984435',5,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'b7ecbdb0-a784-44fc-b2df-d78a39ac538a',6,4,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'a2274c4d-3258-439a-b961-048614b51277',7,3,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'39db6b8c-ff50-46d2-92c3-2ae5423f5bca',8,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'b9bd0f33-6d74-438e-a000-b3c615c1ef90',10,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'f7b1bd19-2697-4d79-a121-d1b43fffe130',11,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'6dc55c1a-e329-4401-b168-4f9bd221584a',12,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'597292e5-30a0-4669-bacc-a15bf419e6f8',13,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'cb666c61-9488-4263-9109-97647d4435d9',14,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'9db7d3f0-52a2-447e-b64d-f4d4fd2c3c13',15,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'6d957e26-744a-4259-8abf-6f60cd44b15a',16,NULL,3,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'15148a7e-87ac-4ab3-8288-087f367fe82c',17,NULL,4,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'3e4ea582-1b4b-4baa-83a4-d7949d452642',18,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'da82728a-120a-499b-9398-81d7ea990811',19,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'f5949487-5943-449b-ac95-907bca42829e',20,NULL,1,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'f3da6f34-74ef-4311-9002-002ab7099e02',21,NULL,1,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'1da69547-e0e1-450f-aea7-901248e76a99',22,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'6f18ba36-afc3-4034-b6eb-6d01eb800380',23,NULL,NULL,NULL,1);
insert into [sal].[fat_factores_tipo_planilla] ([fat_codtpl],[fat_codfac],[fat_precedencia],[fat_codtig],[fat_codtdc],[fat_codtrs],[fat_salva_en_tabla]) values ((select MAX(tpl_codigo) from sal.tpl_tipo_planilla where tpl_descripcion = 'Planilla Décimo III mes' and tpl_codmon = 'PAB'),'d9bab822-bee7-4029-98c7-eb2b96516c83',9,NULL,NULL,NULL,1);


commit transaction;
