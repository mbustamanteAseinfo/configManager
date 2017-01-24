 
-- 'Inserting values into  jor_jornadas '

SET IDENTITY_INSERT sal.jor_jornadas  ON 
INSERT into sal.jor_jornadas  
( jor_codigo ,  jor_codcia ,  jor_codigo_visual ,  jor_descripcion ,  jor_horario ,  
  jor_entrada_marca_dia ,  jor_total_horas ,  jor_estado ,  jor_fecha_cambio_estado ,  jor_property_bag_data , 
  jor_estado_workflow ,  jor_codigo_workflow ,  jor_ingresado_portal ) 
VALUES (
1, 1, '1', 'Jornada Diurna', 'De 8:00 a 6:00', 
1, 44.0000, 'Autorizado', GETDATE(), NULL, 
'Autorizado', NULL, 0);
SET IDENTITY_INSERT sal.jor_jornadas  OFF
 
-- 'Inserting values into  tun_tipos_unidades '
--SET IDENTITY_INSERT eor.tun_tipos_unidades ON 
--INSERT  INTO or.tun_tipos_unidades  (tun_codigo ,  tun_descripcion ,  tun_codgrc ,  tun_property_bag_data )  VALUES (1, 'Directores', 1, NULL);
--SET IDENTITY_INSERT eor_tun_tipos_unidades OFF



