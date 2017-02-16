
GO

/****** Object:  View [exp].[emp_omniexpedientes_v]    Script Date: 07/02/2017 11:41:09 AM ******/
DROP VIEW [exp].[emp_omniexpedientes_v]
GO

/****** Object:  View [exp].[emp_omniexpedientes_v]    Script Date: 07/02/2017 11:41:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [exp].[emp_omniexpedientes_v]
AS
SELECT
  emp_codigo, 
  exp_codigo, 
  exp_codigo_alternativo, 
  exp_apellidos_nombres, 
  exp_edad, 
  exp_sexo, 
  exp_estado_civil, 
  exp_codpai_digita,
  CASE WHEN exp_sexo = 'M' THEN pai_gentilicio_masculino ELSE pai_gentilicio_femenino END AS pai_gentilicio, 
  emp_estado,
  emp_fecha_ingreso,
  emp_fecha_retiro,
  plz_codigo, 
  plz_codcia,
  plz_nombre, 
  plz_max_empleados, 
  plz_es_temporal,
  plz_presupuestada,
  plz_fecha_ini, 
  plz_fecha_fin, 
  plz_estado,
  plz_fecha_estado, 
  cia_descripcion, 
  uni_descripcion, 
  pue_nombre, 
  cdt_descripcion
FROM
  exp.emp_empleos
  JOIN exp.exp_expedientes ON emp_codexp = exp_codigo
  JOIN eor.plz_plazas ON plz_codigo = emp_codplz
  JOIN gen.pai_paises ON pai_codigo = exp_codpai_nacionalidad   
  JOIN eor.cia_companias ON cia_codigo = plz_codcia
  JOIN eor.uni_unidades ON uni_codigo = plz_coduni
  JOIN eor.pue_puestos ON pue_codigo = plz_codpue 
  JOIN eor.cdt_centros_de_trabajo ON cdt_codigo = plz_codcdt

GO


