
/****** Object:  StoredProcedure [rep].[contratos]    Script Date: 07/02/2017 11:40:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedURE [rep].[contratos]
	@candidato1 int,
	@firmante int,
	@fechafirma date
AS
begin
set nocount on
SET LANGUAGE 'Spanish'

DECLARE @dependientes NVARCHAR(1500),
		@codtdo_cedula int,
		@codtdo_seguro int,
		@codrsa_salario int,
		@codcia int

select @codcia = plz_codcia
from exp.emp_empleos
join exp.exp_expedientes
on exp_codigo = emp_codigo
join eor.plz_plazas
on plz_codigo = emp_codplz
where exp_codigo = @candidato1

select @codtdo_cedula = gen.get_valor_parametro_int('CodigoDoc_Cedula', 'pa', null, null, null),
	   @codtdo_seguro = gen.get_valor_parametro_int('CodigoDoc_SeguroSocial', 'pa', null, null, null),
	   @codrsa_salario = gen.get_valor_parametro_int('CodigoRubroSalario', null, null, @codcia, null)

SELECT colaborador.exp_nombres_apellidos nombrecolaborador,
		colaborador.exp_edad edadcolaborador,
		ISNULL(cedula.ide_numero,'[NO POSEE]') cedulacolaborador,
		ISNULL(seguro.ide_numero,'[NO POSEE]') segurocolaborador,
		datename([day],@fechafirma)+' de '+datename([month],@fechafirma)+' de '+convert(varchar(10),year(@fechafirma)) fechafirma,
		plzcol.plz_nombre cargocolaborador,
		cdtcol.cdt_descripcion centrocolaborador,
		convert(numeric(12,2), esecol.ese_valor) salariocolaborador,
		CASE 
			WHEN  sal.cantidadconletra(esecol.ese_valor) LIKE '%un mil%'
			THEN REPLACE(sal.cantidadconletra(esecol.ese_valor), 'UN MIL', 'MIL')
			ELSE
			sal.cantidadconletra(esecol.ese_valor) 
			END	SalLetrasCol,
			tcocol.tco_descripcion,
			datename([day],concol.con_contrato_ini)+' de '+datename([month],concol.con_contrato_ini)+' de '+convert(varchar(10),year(concol.con_contrato_ini)) iniciocolaborador,
			ISNULL('al '+DATENAME([day],concol.con_contrato_ini)+' de '+datename([month],concol.con_contrato_fin)+' de '+convert(varchar(10),year(concol.con_contrato_fin)),'una fecha indefina') fincolaborador,
			jorcol.jor_total_horas jorcolaborador,
			case when colaborador.exp_sexo='F' then 'MUJER' else 'HOMBRE' END sexocolaborador,
			--'<<corregimiento>>' corregimientocolaborador,
			ISNULL(CASE when colaborador.exp_estado_civil='A' then 'Unido/a' when colaborador.exp_estado_civil='C' then 'Casado/a' when colaborador.exp_estado_civil='V' then 'Viudo/a' when colaborador.exp_estado_civil='D' then 'Divorciado/a' END,'Soltero/a') estcivilcolaborador,
			omnicol.pai_gentilicio nacionalidadcol,
			stuff((select', '+ CONVERT(NVARCHAR(5),ROW_NUMBER() OVER(ORDER BY fae.fae_codigo DESC)) +'. ' + fae.fae_nombre + ' (' + prt.prt_descripcion+')' FROM exp.fae_familiares_expedientes fae 
			JOIN exp.prt_parentescos prt on prt.prt_codigo = fae.fae_codprt		WHERE fae.fae_depende =1FOR xml path('')), 1, 1, '') dependientescol,
			--ISNULL(coalesce(@convivientes+', ','')+ convivientecol.fae_nombre,'') convivientecol,
			ISNULL(dex_direccion,'NO TIENE') barriocol,
			ISNULL(mun_descripcion,'NO TIENE') distritocol,
			ISNULL(dep_descripcion,'NO TIENE') provinciacol,
			/*firmante*/
			ISNULL(firmante.exp_nombre_usual,'AGREGAR NOMBRE USUAL') nombrefirmante,
			case when firmante.exp_sexo='F' then 'mujer' else 'hombre' END sexofirmante,
			plzfirmante.plz_nombre cargofirmante,
			cedulafirmante.ide_numero cedulafirmante,
			ISNULL(CASE when firmante.exp_estado_civil='A' then 'Unido/a' when firmante.exp_estado_civil='C' then 'Casado/a' when firmante.exp_estado_civil='V' then 'Viudo/a' when firmante.exp_estado_civil='D' then 'Divorciado/a' END,'Soltero/a') estcivilfirmante,
			omnifirmante.pai_gentilicio nacionalidadfirmante

		 FROM exp.exp_expedientes colaborador
			LEFT JOIN exp.ide_documentos_identificacion cedula ON cedula.ide_codexp = colaborador.exp_codigo AND cedula.ide_codtdo = @codtdo_cedula
			LEFT JOIN exp.ide_documentos_identificacion seguro ON seguro.ide_codexp = colaborador.exp_codigo AND seguro.ide_codtdo = @codtdo_seguro
			JOIN exp.emp_empleos empcol ON empcol.emp_codexp = colaborador.exp_codigo
			JOIN eor.plz_plazas plzcol ON plzcol.plz_codigo = empcol.emp_codplz
			JOIN eor.cdt_centros_de_trabajo cdtcol ON cdtcol.cdt_codigo = plzcol.plz_codcdt 
			JOIN exp.ese_estructura_sal_empleos esecol ON esecol.ese_codemp = empcol.emp_codigo AND esecol.ese_codrsa = @codrsa_salario AND esecol.ese_fecha_fin IS NULL
			JOIN acc.con_contrataciones concol ON concol.con_codemp = empcol.emp_codigo 
			JOIN exp.tco_tipos_de_contrato tcocol ON tcocol.tco_codigo = concol.con_codtco
			JOIN sal.jor_jornadas jorcol ON jorcol.jor_codigo = concol.con_codjor
			--LEFT JOIN exp.fae_familiares_expedientes dependientecol ON dependientecol.fae_codexp = colaborador.exp_codigo and  dependientecol.fae_depende = 1.
			--LEFT JOIN exp.fae_familiares_expedientes convivientecol ON convivientecol.fae_codexp = colaborador.exp_codigo AND  convivientecol.fae_codprt = 14
			JOIN exp.emp_omniexpedientes_v omnicol ON omnicol.emp_codigo = empcol.emp_codigo
			LEFT JOIN exp.dex_direcciones_expediente ON dex_direcciones_expediente.dex_codexp = colaborador.exp_codigo
			LEFT JOIN gen.mun_municipios ON mun_municipios.mun_codigo = dex_direcciones_expediente.dex_codmun
			LEFT JOIN gen.dep_departamentos ON dep_departamentos.dep_codigo = mun_municipios.mun_coddep
			/*firmante*/
			JOIN exp.exp_expedientes firmante ON firmante.exp_codigo = @firmante
			LEFT JOIN exp.ide_documentos_identificacion cedulafirmante ON cedulafirmante.ide_codexp = firmante.exp_codigo AND cedulafirmante.ide_codtdo = @codtdo_cedula
			JOIN exp.emp_empleos empfirmante ON empfirmante.emp_codexp = firmante.exp_codigo
			JOIN eor.plz_plazas plzfirmante ON plzfirmante.plz_codigo = empfirmante.emp_codplz
			JOIN exp.emp_omniexpedientes_v omnifirmante ON omnifirmante.emp_codigo = empfirmante.emp_codigo
			WHERE colaborador.exp_codigo = @candidato1 AND empcol.emp_estado = 'A'
end
