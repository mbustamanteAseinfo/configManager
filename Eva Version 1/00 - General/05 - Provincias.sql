 
SET NOCOUNT ON
 
SET IDENTITY_INSERT [gen].[dep_departamentos] ON
GO
 
 
PRINT 'Inserting values into dep_departamentos'

INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (71, 'pa', 'PANAMA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (72, 'pa', 'VERAGUAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (73, 'pa', 'BOCAS DEL TORO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (74, 'pa', 'CHIRIQUI', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (75, 'pa', 'HERRERA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (76, 'pa', 'LOS SANTOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (77, 'pa', 'COCLE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (78, 'pa', 'COLON', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (79, 'pa', 'DARIEN', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.dep_departamentos (dep_codigo, dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES (80, 'pa', 'SAN BLAS', NULL, NULL, NULL, NULL, NULL, NULL)


PRINT 'Done'
 
 
SET IDENTITY_INSERT [gen].[dep_departamentos] OFF
GO
SET NOCOUNT OFF
