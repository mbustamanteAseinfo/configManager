BEGIN TRAN 
SET IDENTITY_INSERT exp.exp_expedientes ON 
INSERT into exp.exp_expedientes ( 
exp_codigo ,  exp_codigo_alternativo ,  exp_primer_ape ,  exp_segundo_ape ,  exp_apellido_cas ,  
exp_primer_nom ,  exp_segundo_nom ,  exp_otros_nom ,  exp_nombre_usual ,  exp_codpai_nacionalidad ,  
exp_codpai_nacimiento ,  exp_codtip ,  exp_sexo ,  exp_profesion ,  exp_estado_civil ,  
exp_fecha_nac ,  exp_codmun_nac ,  exp_coddep_nac ,  exp_lugar_nac ,  exp_email , 
exp_email_interno ,  exp_telefono_movil ,  exp_codupf ,  exp_observaciones ,  exp_property_bag_data ) 
VALUES
(1, '1', 'Evolution', 'Test', NULL, 
'Empleado', 'Uno', NULL, NULL, 'pa', 
'pa', 1, 'M', 'Licenciado', 'C', 
CONVERT(DATE,'07/09/1967'), 325, 16, NULL, 'test@aseinfo.com.sv', 
'test@aseinfo.com.sv', '5732 0033', NULL, NULL, NULL)
SET IDENTITY_INSERT exp.exp_expedientes Off
COMMIT TRAN 