/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:40 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '86d5188e-2120-49b9-8b98-a57a2d7772bd';

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

commit transaction;
