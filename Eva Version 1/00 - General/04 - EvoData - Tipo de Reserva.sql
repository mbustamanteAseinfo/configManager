 
SET NOCOUNT ON
 DELETE FROM sal.trs_tipos_reserva
SET IDENTITY_INSERT [sal].[trs_tipos_reserva] ON
GO
 
 
PRINT 'Inserting values into trs_tipos_reserva'

INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (1, 1, 'Neto a Pagar', '1', 'Acumulador', 1, 10, NULL, NULL, NULL, NULL, NULL, 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (2, 1, 'Provisión Vacación', 'PROV_VAC', 'Legal', 1, 20, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (3, 1, 'Provisión XIII', 'PROV_XIII', 'Legal', 1, 30, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (4, 1, 'Provisión Indemnización', 'PROV_INDEM', 'Legal', 1, 40, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (5, 1, 'Provisión Prima de Antigüedad', 'PROV_Prima_Anti', 'Legal', 1, 50, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (6, 1, 'Seguro Educativo Patronal', 'PROV_SEPatronal', 'Legal', 1, 60, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (7, 1, 'Seguro Social Patronal', 'PROV_SSPatronal', 'Legal', 1, 70, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)
INSERT sal.trs_tipos_reserva (trs_codigo, trs_codcia, trs_descripcion, trs_abreviatura, trs_tipo, trs_activo, trs_orden, trs_cuenta, trs_cuenta_aux, trs_cuenta_patronal, trs_cuenta_patronal_aux, trs_property_bag_data, trs_estado_workflow, trs_codigo_workflow, trs_ingresado_portal, trs_fecha_grabacion, trs_usuario_grabacion, trs_fecha_modificacion, trs_usuario_modificacion) VALUES (8, 1, 'Provisión Riesgo Profesional', 'PROV_Riesgo', 'Legal', 1, 80, NULL, NULL, NULL, NULL, '', 'Autorizado', NULL, 0, NULL, 'Administrador', NULL, NULL)

PRINT 'Done'
 
 
SET IDENTITY_INSERT [sal].[trs_tipos_reserva] OFF
GO
SET NOCOUNT OFF
