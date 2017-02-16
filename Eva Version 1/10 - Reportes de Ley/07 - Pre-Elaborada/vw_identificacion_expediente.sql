
/****** Object:  View [pa].[vw_identificacion_expediente]    Script Date: 07/02/2017 10:52:19 AM ******/
DROP VIEW [pa].[vw_identificacion_expediente]
GO

/****** Object:  View [pa].[vw_identificacion_expediente]    Script Date: 07/02/2017 10:52:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [pa].[vw_identificacion_expediente]
AS
SELECT codexp, cip, isss, pasaporte, cip_sipe, isss_sipe, cedula_css_extranjero, ficha_css,
		   RIGHT(SPACE(15) + CASE gen.fn_contar_caracteres(cip_sipe,'-') 
					WHEN 2 THEN
							(CASE 
								WHEN gen.fn_esLetra(SUBSTRING(gen.fn_get_token(cip_sipe,'-',1), 1, 1)) +
									 gen.fn_esLetra(SUBSTRING(gen.fn_get_token(cip_sipe,'-',1), 2, 1)) > 0
								THEN gen.lpad(REPLACE(gen.fn_get_token(cip_sipe,'-',1), '0', ''), 3, SPACE(1)) + SPACE(1)
								--gen.lpad(gen.fn_get_token(cip_sipe,'-',1),2,'0')
								ELSE gen.lpad(CONVERT(VARCHAR, CONVERT(NUMERIC, gen.fn_get_token(cip_sipe,'-',1))), 2, '0') + SPACE(2)
							 END)
							 + 
						gen.lpad(gen.fn_get_token(cip_sipe,'-',2),5,'0') +
						gen.lpad(gen.fn_get_token(cip_sipe,'-',3),6,'0') 
					WHEN 3 THEN
						gen.lpad(gen.fn_get_token(cip_sipe,'-',1),2,'0') + 
						gen.lpad(gen.fn_get_token(cip_sipe,'-',2),2,SPACE(1)) + 
						gen.lpad(gen.fn_get_token(cip_sipe,'-',3),5,'0') + 
						gen.lpad(gen.fn_get_token(cip_sipe,'-',4),6,'0')
					WHEN 1 THEN
						(CASE WHEN ASCII(RIGHT(gen.fn_get_token(cip_sipe,'-',1), 1)) >= 48 
								   AND ASCII(RIGHT(gen.fn_get_token(cip_sipe,'-',1), 1)) <= 57
								THEN gen.lpad(gen.fn_get_token(cip_sipe,'-',1),2,'0') + SPACE(2)
								ELSE SPACE(2) + gen.rpad(gen.fn_get_token(cip_sipe,'-',1),2,SPACE(1))
								END) +
							gen.lpad(gen.fn_get_token(cip_sipe,'-',2),11,'0') 
					ELSE
						ISNULL(cip_sipe,'')
				END
			   , 15)  -- Cédula, LONG.MAX = 15
			id_formato_sipe
FROM (
	SELECT codexp, cip, isss, pasaporte,
		   (CASE cedula_css_extranjero
			WHEN '' THEN 
				(CASE WHEN isss = cip 
					THEN '9999999' 
					ELSE (CASE WHEN cip = '' 
							THEN isss 
							ELSE cip 
						  END)
					END)
				ELSE cedula_css_extranjero
				END)
			cip_sipe, 
		   (CASE WHEN isss = '' THEN '' WHEN isss = cip THEN '9999999' ELSE isss END) isss_sipe,
		   cedula_css_extranjero,
		   ficha_css
	FROM (
		SELECT codexp, cip, isss, pasaporte, cedula_css_extranjero, ficha_css --, cip cip_sipe
		FROM (
			SELECT exp_codigo codexp, MAX(cip) cip, MAX(isss) isss, MAX(pasaporte) pasaporte, MAX(cedula_css_extranjero) cedula_css_extranjero, MAX(ficha_css) ficha_css
			FROM (
				SELECT exp_codigo, ISNULL(ide_numero, '') cip, '' isss, '' pasaporte, '' cedula_css_extranjero, '' ficha_css
				FROM exp.exp_expedientes
				JOIN exp.ide_documentos_identificacion
				ON ide_codexp = exp_codigo
				WHERE ide_codtdo = gen.get_valor_parametro_varchar('CodigoDoc_Cedula','pa',NULL,NULL,NULL)
				UNION
				SELECT exp_codigo, '' cip, ISNULL(ide_numero, '') isss, '' pasaporte, '' cedula_css_extranjero, '' ficha_css
				FROM exp.exp_expedientes
				JOIN exp.ide_documentos_identificacion
				ON ide_codexp = exp_codigo
				WHERE ide_codtdo = gen.get_valor_parametro_varchar('CodigoDoc_SeguroSocial','pa',NULL,NULL,NULL)
				UNION
				SELECT exp_codigo, '' cip, '' isss, ISNULL(ide_numero, '') pasaporte, '' cedula_css_extranjero, '' ficha_css
				FROM exp.exp_expedientes
				JOIN exp.ide_documentos_identificacion
				ON ide_codexp = exp_codigo
				WHERE ide_codtdo = gen.get_valor_parametro_varchar('CodigoDoc_Pasaporte','pa',NULL,NULL,NULL)
				UNION
				SELECT exp_codigo, '' cip, '' isss, '' pasaporte, ISNULL(ide_numero, '') cedula_css_extranjero, '' ficha_css
				FROM exp.exp_expedientes
				JOIN exp.ide_documentos_identificacion
				ON ide_codexp = exp_codigo
				WHERE ide_codtdo = gen.get_valor_parametro_varchar('CodigoDoc_CedulaCSSExtranjeros','pa',NULL,NULL,NULL)
				UNION
				SELECT exp_codigo, '' cip, '' isss, '' pasaporte, '' cedula_css_extranjero, ISNULL(ide_numero, '') ficha_css
				FROM exp.exp_expedientes
				JOIN exp.ide_documentos_identificacion
				ON ide_codexp = exp_codigo
				WHERE ide_codtdo = gen.get_valor_parametro_varchar('CodigoDoc_FichaDigitalCSS','pa',NULL,NULL,NULL)
			) v
			GROUP BY exp_codigo
		) w
	) x
) y




GO


