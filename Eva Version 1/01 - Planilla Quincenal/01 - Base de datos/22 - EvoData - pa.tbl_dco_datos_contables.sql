
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.dco_datos_contables')
                    AND type IN ( N'S', N'U' ) )
					begin
ALTER TABLE [pa].[dco_datos_contables] DROP CONSTRAINT [fk_salppl_padco];

ALTER TABLE [pa].[dco_datos_contables] DROP CONSTRAINT [fk_expemp_padco];

/****** Object:  Table [pa].[dco_datos_contables]    Script Date: 16-01-2017 2:20:24 PM ******/
DROP TABLE [pa].[dco_datos_contables];
end
GO

/****** Object:  Table [pa].[dco_datos_contables]    Script Date: 16-01-2017 2:20:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [pa].[dco_datos_contables](
	[dco_codcia] [INT] NULL,
	[dco_codtpl] [INT] NULL,
	[dco_codppl] [INT] NULL,
	[dco_tipo_partida] [VARCHAR](1) NULL,
	[dco_grupo] [VARCHAR](20) NULL,
	[dco_centro_costo] [VARCHAR](50) NULL,
	[dco_linea] [INT] NULL,
	[dco_mes] [INT] NULL,
	[dco_anio] [INT] NULL,
	[dco_cta_contable] [VARCHAR](40) NULL,
	[dco_descripcion] [VARCHAR](300) NULL,
	[dco_debitos] [MONEY] NULL,
	[dco_creditos] [MONEY] NULL,
	[dco_codemp] [INT] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO

ALTER TABLE [pa].[dco_datos_contables]  WITH CHECK ADD  CONSTRAINT [fk_expemp_padco] FOREIGN KEY([dco_codemp])
REFERENCES [exp].[emp_empleos] ([emp_codigo])
GO

ALTER TABLE [pa].[dco_datos_contables] CHECK CONSTRAINT [fk_expemp_padco]
GO

ALTER TABLE [pa].[dco_datos_contables]  WITH CHECK ADD  CONSTRAINT [fk_salppl_padco] FOREIGN KEY([dco_codppl])
REFERENCES [sal].[ppl_periodos_planilla] ([ppl_codigo])
GO

ALTER TABLE [pa].[dco_datos_contables] CHECK CONSTRAINT [fk_salppl_padco]
GO


