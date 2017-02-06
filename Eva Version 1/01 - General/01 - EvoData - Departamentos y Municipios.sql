
declare @coddep int
if exists (select 1 from gen.dep_departamentos where dep_codpai = 'pa')
	begin
		delete from gen.mun_municipios where mun_coddep in (select dep_codigo from gen.dep_departamentos where dep_codpai = 'pa')
		delete from gen.dep_departamentos where dep_codpai = 'pa'
	end
	

INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'PANAMA', NULL, NULL, NULL, NULL, NULL, NULL)
Set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PANAMA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BALBOA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHEPO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LA CHORRERA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'ARRAIJ�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CAPIRA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHAME', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHIM�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN CARLOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN MIGUELITO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'TABOGA', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'VERAGUAS', NULL, NULL, NULL, NULL, NULL, NULL)
Set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SANTA FE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SANTIAGO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'ATALAYA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CALOBRE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CA�AZAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LA MESA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LAS PALMAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'MONTIJO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'R�OS DE JESUS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN FRANCISCO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SON�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'KUNA YALA', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'BOCAS DEL TORO', NULL, NULL, NULL, NULL, NULL, NULL)
Set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BOCAS DEL TORO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHANGUINOLA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHIRIQUI GRANDE', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'CHIRIQUI', NULL, NULL, NULL, NULL, NULL, NULL)
Set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'ALANJE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BARU', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'DAVID', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BOQUER�N', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BOQUETE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'BUGABA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'DOLEGA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'GUALACA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'REMEDIOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'RENACIMIENTO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN F�LIX', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN LORENZO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'TOL�', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'HERRERA', NULL, NULL, NULL, NULL, NULL, NULL)
Set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHITRE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LAS MINAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LOS POZOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'OC�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PARITA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PES�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SANTA MAR�A', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'LOS SANTOS', NULL, NULL, NULL, NULL, NULL, NULL)
set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LAS TABLAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'LOS SANTOS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'MACARACAS', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PEDAS�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'POCR�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'TONOS�', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'COCLE', NULL, NULL, NULL, NULL, NULL, NULL)
set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep , 'ANTON', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep , 'LA PINTADA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep , 'PENONOME', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep , 'AGUADULCE', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'NAT�', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'OL�', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'COLON', NULL, NULL, NULL, NULL, NULL, NULL)
set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'COLON', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PORTOBELO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHAGRES', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'DONOSO', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SANTA ISABEL', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'DARIEN', NULL, NULL, NULL, NULL, NULL, NULL)
set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'PINOGANA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT gen.mun_municipios (mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'CHEPIGANA', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT gen.dep_departamentos ( dep_codpai, dep_descripcion, dep_abreviatura, dep_property_bag_data, dep_usuario_grabacion, dep_fecha_grabacion, dep_usuario_modificacion, dep_fecha_modificacion) VALUES ('pa', 'SAN BLAS', NULL, NULL, NULL, NULL, NULL, NULL)
set @coddep = @@IDENTITY
if exists(select 1 from gen.mun_municipios where mun_coddep = @coddep)
	delete from gen.mun_municipios where mun_coddep = @coddep
INSERT gen.mun_municipios ( mun_coddep, mun_descripcion, mun_abreviatura, mun_property_bag_data, mun_usuario_grabacion, mun_fecha_grabacion, mun_usuario_modificacion, mun_fecha_modificacion) VALUES (@coddep, 'SAN BLAS', NULL, NULL, NULL, NULL, NULL, NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT 'Inserting values into mun_municipios'