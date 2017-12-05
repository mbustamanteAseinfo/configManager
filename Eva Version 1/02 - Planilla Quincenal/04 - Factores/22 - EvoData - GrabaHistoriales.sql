/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:46 AM */

begin transaction

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

commit transaction;
