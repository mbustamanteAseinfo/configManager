IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.iss_seguro')
                    AND type IN ( N'U', N'TT' ) )
/****** Object:  Table [pa].[iss_seguro]    Script Date: 07/02/2017 10:51:31 AM ******/
DROP TABLE [pa].[iss_seguro]
GO
CREATE TABLE [pa].[iss_seguro](
	[iss_codcia] [INT] NULL,
	[iss_anio] [INT] NULL,
	[iss_mes] [INT] NULL,
	[iss_codemp] [INT] NULL,
	[iss_codigo_rubro] [VARCHAR](2) NULL,
	[iss_devengado] [NUMERIC](12, 2) NULL,
	[iss_renta] [NUMERIC](12, 2) NULL,
	[iss_aporte_empleado] [NUMERIC](12, 2) NULL,
	[iss_aporte_patronal] [NUMERIC](12, 2) NULL,
	[iss_otros] [NUMERIC](12, 2) NULL,
	[iss_es_decimo] [INT] NULL,
	[iss_observaciones] [VARCHAR](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO


