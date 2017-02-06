/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:15 PM */

begin transaction

ALTER TABLE sal.ftp_formulacion_tipos_planilla
NOCHECK CONSTRAINT fk_salfac_salftp; 

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

ALTER TABLE sal.ftp_formulacion_tipos_planilla
CHECK CONSTRAINT fk_salfac_salftp; 

commit transaction;
