-----------------------------------------------------------------------------------------------------
-----------------------------------------Planilla Quincenal------------------------------------------
-----------------------------------------------------------------------------------------------------
--Creamos parametro siempre y cuando no exista
INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT distinct 'CodigoPlanillaQuincenal' , -- par_codigo - varchar(100)
          'Codigo de Planilla Quincenal' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoPlanillaQuincenal')

--Insertamos el valor correspondiente a la planilla quincenal en los alcances

--ATENCION: LEER EL INSERT ANTES DE EJECUTARLO, TOMAR EN CUENTA QUE SOLO SE CONTEMPLA UNA COMPAÑIA
DELETE FROM gen.apa_alcances_parametros WHERE apa_codpar='CodigoPlanillaQuincenal' AND apa_codpai='pa'

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select distinct NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'CodigoPlanillaQuincenal' , -- apa_codpar - varchar(100)
		  'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          tpl_codigo , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
        FROM sal.tpl_tipo_planilla
		JOIN eor.cia_companias ON cia_companias.cia_codigo = tpl_tipo_planilla.tpl_codcia
		JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
		WHERE tpl_descripcion LIKE '%Quincena%'
		AND cia_codpai='pa'



----Parametros de rubros salariales
--Salario
INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT	distinct  'CodigoRubroSalario' , -- par_codigo - varchar(100)
          'Codigo de rubro salarial ***SALARIO***' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoRubroSalario')


--Alcance de rubro salarial ***SALARIO*** 

DELETE FROM gen.apa_alcances_parametros WHERE apa_codpar='CodigoRubroSalario' AND apa_codpai='pa'

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select	distinct  NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'CodigoRubroSalario' , -- apa_codpar - varchar(100)
		  'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          rsa_codigo , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
		  FROM exp.rsa_rubros_salariales
		  JOIN eor.cia_companias ON cia_companias.cia_codigo = rsa_rubros_salariales.rsa_codcia
		  JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
		  WHERE rsa_descripcion LIKE '%Salario%'
		  AND cia_codpai ='pa'


--Salario
INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT distinct 'CodigoRubroGastoRep' , -- par_codigo - varchar(100)
          'Codigo de rubro salarial ***GASTO DE REPRESETACIÓN***' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoRubroGastoRep')


--Alcance de rubro salarial ***SALARIO*** 

DELETE FROM gen.apa_alcances_parametros WHERE apa_codpar='CodigoRubroGastoRep' AND apa_codpai='pa'

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select	distinct  NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'CodigoRubroGastoRep' , -- apa_codpar - varchar(100)
		  'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          rsa_codigo , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
		  FROM exp.rsa_rubros_salariales
		  JOIN eor.cia_companias ON cia_companias.cia_codigo = rsa_rubros_salariales.rsa_codcia
		  JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
		  WHERE rsa_descripcion LIKE '%Gasto de Rep%'
		  AND cia_codpai ='pa'


--Parametro de riesgo de fondo de incapacidad

INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT	distinct  'CodigoRiesgoFondo' , -- par_codigo - varchar(100)
          'Codigo de riesgo de fondo de incapacidad' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoRiesgoFondo')


--Parametro de deduccion legal para el calculo de renta 

INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT	distinct  'ISRDeduccionLegal' , -- par_codigo - varchar(100)
          'Valor de la deducción Legal del ISR' , -- par_descripcion - varchar(400)
          'Double' , -- par_tipo - varchar(10)
          'Valor' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('ISRDeduccionLegal')

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select distinct NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'ISRDeduccionLegal' , -- apa_codpar - varchar(100)
          'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          '800' , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
      FROM gen.pai_paises 
	  JOIN eor.cia_companias ON cia_companias.cia_codpai = pai_paises.pai_codigo
	  JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
	  WHERE pai_codigo='pa'


-----------------------------------------------------------------------------------------------------
-----------------------------------------Planilla Vacaciones-----------------------------------------
-----------------------------------------------------------------------------------------------------

--Creamos parametro siempre y cuando no exista
INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT distinct 'CodigoPlanillaVacacion' , -- par_codigo - varchar(100)
          'Codigo de Planilla de Vacaciones' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoPlanillaVacacion')


--Insertamos el valor correspondiente a la planilla quincenal en los alcances

--ATENCION: LEER EL INSERT ANTES DE EJECUTARLO, TOMAR EN CUENTA QUE SOLO SE CONTEMPLA UNA COMPAÑIA
DELETE FROM gen.apa_alcances_parametros WHERE apa_codpar='CodigoPlanillaVacacion'

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select	distinct  NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'CodigoPlanillaVacacion' , -- apa_codpar - varchar(100)
		  'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          tpl_codigo , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
        FROM sal.tpl_tipo_planilla
		JOIN eor.cia_companias ON cia_companias.cia_codigo = tpl_tipo_planilla.tpl_codcia
		JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
		AND tpl_descripcion LIKE '%Vacacion%'
		AND cia_codpai='pa'









-----------------------------------------------------------------------------------------------------
-----------------------------------------Planilla Decimo---------------------------------------------
-----------------------------------------------------------------------------------------------------

--Creamos parametro siempre y cuando no exista
INSERT INTO gen.par_parametros
        ( par_codigo ,
          par_descripcion ,
          par_tipo ,
          par_unidad_medida ,
          par_tipo_valor ,
          par_property_bag_data ,
          par_usuario_grabacion ,
          par_fecha_grabacion ,
          par_usuario_modificacion ,
          par_fecha_modificacion
        )
SELECT distinct 'CodigoPlanillaDecimo' , -- par_codigo - varchar(100)
          'Codigo de Planilla de Decimo' , -- par_descripcion - varchar(400)
          'Integer' , -- par_tipo - varchar(10)
          'Código' , -- par_unidad_medida - varchar(50)
          'E' , -- par_tipo_valor - char(1)
          NULL , -- par_property_bag_data - xml
          'Administrador' , -- par_usuario_grabacion - varchar(50)
          GETDATE() , -- par_fecha_grabacion - datetime
          NULL , -- par_usuario_modificacion - varchar(50)
          NULL  -- par_fecha_modificacion - datetime
        FROM gen.par_parametros
WHERE par_codigo NOT IN ('CodigoPlanillaDecimo')


--Insertamos el valor correspondiente a la planilla quincenal en los alcances

--ATENCION: LEER EL INSERT ANTES DE EJECUTARLO, TOMAR EN CUENTA QUE SOLO SE CONTEMPLA UNA COMPAÑIA
DELETE FROM gen.apa_alcances_parametros WHERE apa_codpar='CodigoPlanillaDecimo'

INSERT INTO gen.apa_alcances_parametros
        ( apa_fecha_inicio ,
          apa_fecha_final ,
          apa_codpar ,
          apa_codpai ,
          apa_codgrc ,
          apa_codcia ,
          apa_codcdt ,
          apa_valor ,
          apa_usuario_grabacion ,
          apa_fecha_grabacion ,
          apa_usuario_modificacion ,
          apa_fecha_modificacion
        )
select	distinct  NULL , -- apa_fecha_inicio - datetime
          NULL , -- apa_fecha_final - datetime
          'CodigoPlanillaDecimo' , -- apa_codpar - varchar(100)
		  'pa' , -- apa_codpai - varchar(2)
          grc_codigo , -- apa_codgrc - int
          cia_codigo , -- apa_codcia - int
          NULL , -- apa_codcdt - int
          tpl_codigo , -- apa_valor - varchar(255)
          'Administrador' , -- apa_usuario_grabacion - varchar(50)
          GETDATE() , -- apa_fecha_grabacion - datetime
          NULL , -- apa_usuario_modificacion - varchar(50)
          NULL  -- apa_fecha_modificacion - datetime
        FROM sal.tpl_tipo_planilla
		JOIN eor.cia_companias ON cia_companias.cia_codigo = tpl_tipo_planilla.tpl_codcia
		JOIN eor.grc_grupos_corporativos ON grc_grupos_corporativos.grc_codigo = cia_companias.cia_codgrc
		AND tpl_descripcion LIKE '%Decimo%' OR tpl_descripcion LIKE '%xiii%'
		AND cia_codpai='pa'



