/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:35 PM */

begin transaction
ALTER TABLE sal.ftp_formulacion_tipos_planilla
NOCHECK CONSTRAINT fk_salfac_salftp; 

delete from [sal].[fac_factores] where [fac_codigo] = '7217DB5E-140E-436F-BC30-A21EEB5098B8';

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

ALTER TABLE sal.ftp_formulacion_tipos_planilla
CHECK CONSTRAINT fk_salfac_salftp; 

commit transaction;
