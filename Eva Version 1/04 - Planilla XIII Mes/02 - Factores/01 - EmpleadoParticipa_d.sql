/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:08 PM */

begin transaction

ALTER TABLE sal.ftp_formulacion_tipos_planilla
NOCHECK CONSTRAINT fk_salfac_salftp; 

delete from [sal].[fac_factores] where [fac_codigo] = '1a6f3ab6-13a3-47a4-96d5-16a695850a05';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1a6f3ab6-13a3-47a4-96d5-16a695850a05','EmpleadoParticipa_d','Determina si el empleado participa del calculo de esta planilla','Function EmpleadoParticipa_d()

b = Emp_InfoSalario.Fields("EMP_FECHA_INGRESO").Value <= Pla_Periodo.Fields("PPL_FECHA_FIN").Value _ 
    and Emp_InfoSalario.Fields("dpl_suspendido").Value = "N" AND Emp_InfoSalario.Fields("emp_estado").Value = "A"

EmpleadoParticipa_d = b


End Function','boolean','pa',0);

ALTER TABLE sal.ftp_formulacion_tipos_planilla
CHECK CONSTRAINT fk_salfac_salftp;

commit transaction;
