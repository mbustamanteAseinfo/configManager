
/****** Object:  StoredProcedure [rep].[ref_laboral]    Script Date: 07/02/2017 11:54:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC rep.ref_laboral @empleado_retirado1 = '103','' -- varchar(20)

ALTER procedURE [rep].[ref_laboral]
@empleado_retirado1 varchar(20),
@jefe VARCHAR(20)


as
set nocount on
SET LANGUAGE 'Spanish'

SELECT	
		/*Colaborador*/
		ISNULL(CASE colaborador.exp_sexo when 'M' 
									then 'El '+ coltitulo.tip_descripcion
									ELSE 'La '+ coltitulo.tip_descripcion
									END,CASE colaborador.exp_sexo when 'M' 
									then 'El señor'
									ELSE 'La señora'
									END ) titulo,
		colaborador.exp_nombres_apellidos nombres,
		colaborador.exp_primer_ape apellido,
		colplz.plz_nombre plaza, 
		datename([day],colemp.emp_contrato_ini)+' de '+datename([month],colemp.emp_contrato_ini)+' de '+convert(varchar(10),year(colemp.emp_contrato_ini)) fecha_inicio,
		datename([day],colemp.emp_fecha_retiro)+' de '+datename([month],colemp.emp_fecha_retiro)+' de '+convert(varchar(10),year(colemp.emp_fecha_retiro)) fehca_retiro,
		ide_numero cedula,
		datename([day],getdate())+' de '+datename([month],getdate())+' de '+convert(varchar(10),year(getdate())) fecha_hoy,
		/*Jefe*/
		(case ISNULL(titulojefe.tip_descripcion,'') when '' then '' else ISNULL(titulojefe.tip_descripcion,'') + ' ' end) titulojefe,
		jefe.exp_nombres_apellidos nombrejefe,
		plzjefe.plz_nombre plazajefe
	FROM exp.exp_expedientes colaborador
		JOIN exp.emp_empleos colemp ON colemp.emp_codexp = colaborador.exp_codigo
		JOIN eor.plz_plazas colplz ON colplz.plz_codigo = colemp.emp_codplz
		JOIN exp.ide_documentos_identificacion ON ide_documentos_identificacion.ide_codexp = colaborador.exp_codigo
		LEFT JOIN exp.tip_titulos_personales coltitulo ON coltitulo.tip_codigo = colaborador.exp_codtip
		JOIN exp.exp_expedientes jefe  ON jefe.exp_codigo_alternativo = @jefe
		JOIN exp.emp_empleos empjefe ON empjefe.emp_codexp = jefe.exp_codigo
		JOIN eor.plz_plazas plzjefe ON plzjefe.plz_codigo = empjefe.emp_codplz
		LEFT JOIN exp.tip_titulos_personales titulojefe ON titulojefe.tip_codigo = jefe.exp_codtip
	WHERE colaborador.exp_codigo_alternativo = @empleado_retirado1  AND colemp.emp_estado = 'R' AND ide_codtdo = gen.get_valor_parametro_int('CodigoDoc_Cedula', 'pa', null, null, null)
