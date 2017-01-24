/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:39 AM */

begin transaction

ALTER TABLE sal.ftp_formulacion_tipos_planilla
NOCHECK CONSTRAINT fk_salfac_salftp; 

delete from [sal].[fac_factores] where [fac_codigo] = '1c322de6-4789-4232-bc28-a148e5e45a8e';


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

ALTER TABLE sal.ftp_formulacion_tipos_planilla
CHECK CONSTRAINT fk_salfac_salftp; 

commit transaction;
