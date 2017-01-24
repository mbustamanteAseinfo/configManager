-- 'Inserting values into  ncc_niveles_comportamientos '
SET IDENTITY_INSERT eor.ncc_niveles_comportamientos ON 
INSERT into eor.ncc_niveles_comportamientos
( ncc_codigo ,  ncc_descripcion ,  ncc_abreviatura ,  ncc_codigo_alterno ,  ncc_codgrc  ) 
VALUES (1, 'Administrativos', '1', '1', 1);

INSERT into eor.ncc_niveles_comportamientos 
( ncc_codigo ,  ncc_descripcion ,  ncc_abreviatura ,  ncc_codigo_alterno ,  ncc_codgrc  ) 
 VALUES (2, 'Operativos', '2', '2', 1) ;
 SET IDENTITY_INSERT eor.ncc_niveles_comportamientos Off 
 
--'Inserting values into  pue_puestos '
SET IDENTITY_INSERT eor.pue_puestos ON 
INSERT INTO eor.pue_puestos  
( pue_codigo ,  pue_codtpp ,  pue_nombre ,  pue_codgrc ,  pue_definicion , 
  pue_estado ,  pue_fecha_supre ,  pue_edad_min ,  pue_edad_max ,  pue_est_civil , 
  pue_sexo ,  pue_objetivo ,  pue_indicador_cumplimiento ,  pue_codncc ,  pue_property_bag_data , 
  pue_estado_workflow ,  pue_codigo_workflow ,  pue_ingresado_portal ,  pue_usuario_grabacion ,  pue_fecha_grabacion ,  
  pue_usuario_modificacion ,  pue_fecha_modificacion ) 
VALUES 
(1, 1, 'Gerente General', 1, '1210 Gerente General', 
'V', NULL, 0, 99, 'N', 
'N', NULL, NULL, 1, '<DocumentElement><Puestos><pue_codpue_mt>1210</pue_codpue_mt></Puestos></DocumentElement>',
'Autorizado', NULL, 0, NULL, NULL, 
'admin', GETDATE());
SET IDENTITY_INSERT eor.pue_puestos off 

SET IDENTITY_INSERT eor.cdt_centros_de_trabajo ON 
INSERT INTO eor.cdt_centros_de_trabajo
(CDT_CODIGO,CDT_CODCIA,CDT_CODMUN,CDT_DESCRIPCION,CDT_DIRECCION,
 CDT_TELEFONO,CDT_FAX,CDT_ESTADO,CDT_FECHA_CAMBIO_ESTADO,
 CDT_COMENTARIO_ANULACION,CDT_PROPERTY_BAG_DATA,CDT_ESTADO_WORKFLOW,CDT_CODIGO_WORKFLOW,CDT_INGRESADO_PORTAL) 
 VALUES
 (1,1,325,'Oficinas Centrales','Dirección a definir',
 NULL,NULL,'Vigente',CONVERT(DATE,'2011-01-24 18:50:48'),
 NULL,NULL,'Autorizado',NULL,0);
 SET IDENTITY_INSERT eor.cdt_centros_de_trabajo Off 

SET IDENTITY_INSERT eor.uni_unidades ON 
INSERT INTO eor.uni_unidades 
(UNI_CODIGO,UNI_CODGRC,UNI_DESCRIPCION,UNI_CODCIA,UNI_CODPAI,
 UNI_CODARF,UNI_CODUNI_PADRE,UNI_NIVEL,UNI_STAFF,UNI_CODTUN,
 UNI_CODEMP,UNI_ESTADO,UNI_FECHA_CAMBIO_ESTADO,UNI_COMENTARIO_ANULACION,UNI_PROPERTY_BAG_DATA,
 UNI_ESTADO_WORKFLOW,UNI_CODIGO_WORKFLOW,UNI_INGRESADO_PORTAL) 
 VALUES
 (1,1,'Presidencia',1,'pa',
  2, NULL,0,0,1,
  NULL,'Vigente',CONVERT (DATE,'2011-01-24 18:51:37'),NULL,NULL,
  'Autorizado',NULL,0);
SET IDENTITY_INSERT eor.uni_unidades OFF 
-- 'Inserting values into  plz_plazas '

SET IDENTITY_INSERT eor.plz_plazas ON 
INSERT  INTO eor.plz_plazas  
( plz_codigo ,  plz_nombre ,  plz_codcia ,  plz_coduni ,  plz_codpue ,  
  plz_codcdt ,  plz_max_empleados ,  plz_es_temporal ,  plz_fecha_ini ,  plz_fecha_fin ,  
  plz_estado ,  plz_fecha_estado ,  plz_property_bag_data ,  plz_estado_workflow ,  plz_codigo_workflow ,  
  plz_ingresado_portal  ) 
VALUES 
(1, 'Gerente General', 1, 1, 1, 
 1, 0, 0, GETDATE(), NULL, 
 'V', NULL, NULL, 'Autorizado', NULL, 
 0);
SET IDENTITY_INSERT eor.plz_plazas off
