BEGIN TRANSACTION
 
DECLARE @rfl_repid INT
 
--Elimina los datos de los parámetros de las consultas y sus reportes asociados

DELETE FROM wrp.bre_bitacora_reportes where bre_codrep in (select rep_repid from wrp.rep_reportes where rep_setkey = 'EstructuraOrganizativa')
DELETE FROM wrp.rfl_rep_fields where rfl_repid in (select rep_repid from wrp.rep_reportes where rep_setkey = 'EstructuraOrganizativa')
DELETE FROM wrp.rep_reportes WHERE rep_setkey = 'EstructuraOrganizativa'
DELETE FROM wrp.set_sets WHERE set_setkey = 'EstructuraOrganizativa'

--CONSULTA

INSERT INTO wrp.set_sets VALUES('EstructuraOrganizativa', 'Estructura Organizativa', 0, 'Muestra la estructura de la organización', 'Estructura Organizativa', 'Estructura Organizativa', 'Aseinfo', 'eor.estructura_organizativa_V', 'codigo_compania = $$CODCIA$$', NULL, NULL, 'jcsoria', 'Feb 10 2017 11:14AM')
 
--MODULOS
INSERT INTO wrp.sdm_set_modules VALUES('EstructuraOrganizativa', 'Estructura')
 
--CAMPOS
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'cdt_codigo', 'Codigo Centro de Trabajo', 130, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'cdt_descripcion', 'Nombre Centro de Trabajo', 140, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'codigo_compania', 'Codigo Compañia', 10, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'codigo_plaza_hija', 'Codigo Plaza Hija', 90, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'codigo_plaza_padre', 'Codigo Plaza Padre', 70, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'codigo_unidad_hija', 'Codigo Unidad Hija', 50, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'codigo_unidad_padre', 'Codigo Unidad Padre', 30, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'compania', 'Nombre Compañia', 20, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'plaza_hija', 'Nombre Plaza Hija', 100, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'plaza_padre', 'Nombre Plaza Padre', 80, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'pue_codigo', 'Codigo Puesto', 110, 'int', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'pue_nombre', 'Nombre Puesto', 120, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'unidad_hija', 'Nombre Unidad Hija', 60, 'string', NULL, 1, 'W', 0, NULL)
INSERT INTO wrp.sdf_set_fields VALUES('EstructuraOrganizativa', 'unidad_padre', 'Nombre Unidad Padre', 40, 'string', NULL, 1, 'W', 0, NULL)
 
INSERT INTO wrp.sdr_set_roles VALUES ('EstructuraOrganizativa', 'Administrador')

--REPORTES
INSERT INTO wrp.rep_reportes VALUES('Reporte Unidades de Compañia', 'Unidades de la Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reporte Unidades de Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_unidad_hija', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'unidad_hija', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'unidad_hija', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reporte Jerarquia Unidades de Compañia', 'Jerarquia Unidades de Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, 'jcsoria', 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reporte Jerarquia Unidades de Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_unidad_hija', 'EstructuraOrganizativa', 2, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_unidad_padre', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'unidad_hija', 'EstructuraOrganizativa', 3, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'unidad_padre', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'unidad_padre', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reporte Puestos de la Compañia', 'Puestos de la Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reporte Puestos de la Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'pue_codigo', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'pue_nombre', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'pue_nombre', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reporte Centros de Trabajo de la Compañia', 'Centros de Trabajo de la Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reporte Centros de Trabajo de la Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'cdt_codigo', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'cdt_descripcion', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'cdt_descripcion', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reportes de Plazas de la Compañia', 'Plazas de la Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reportes de Plazas de la Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_plaza_hija', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'plaza_hija', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'plaza_hija', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reportes Jerarquia de Plazas Compañia', 'Jerarquia de Plazas Compañia', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reportes Jerarquia de Plazas Compañia' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_plaza_hija', 'EstructuraOrganizativa', 2, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_plaza_padre', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'plaza_hija', 'EstructuraOrganizativa', 3, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'plaza_padre', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'plaza_padre', 1, 1)
 
--CONSULTA
INSERT INTO wrp.rep_reportes VALUES('Reporte Distribucición de Puestos', 'Distribucición de Puestos', 'Aseinfo', 'Descripcion', 'EstructuraOrganizativa', 0, 'jcsoria', NULL, NULL, 'Feb 10 2017 11:14AM')
 
SELECT @rfl_repid = rep_repid FROM wrp.rep_reportes WHERE rep_nombre ='Reporte Distribucición de Puestos' AND rep_setkey ='EstructuraOrganizativa'
 
--CAMPOS DE REPORTES
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'cdt_codigo', 'EstructuraOrganizativa', 4, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'cdt_descripcion', 'EstructuraOrganizativa', 5, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'codigo_unidad_hija', 'EstructuraOrganizativa', 0, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'pue_codigo', 'EstructuraOrganizativa', 2, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'pue_nombre', 'EstructuraOrganizativa', 3, 'None', 1)
INSERT INTO wrp.rfl_rep_fields VALUES( @rfl_repid, 'unidad_hija', 'EstructuraOrganizativa', 1, 'None', 1)
 
--AGRUPAMIENTO
 
--ORDENAR
INSERT INTO wrp.rfs_rep_field_sort VALUES(@rfl_repid, 'cdt_descripcion', 1, 1)
 
--CONSULTA
 
COMMIT TRANSACTION


