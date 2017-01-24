IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.dpx_datos_prom_xiii')
                    AND type IN ( N'S', N'U' ) )

/****** Object:  Table [pa].[dpx_datos_prom_xiii]    Script Date: 16-01-2017 2:50:38 PM ******/
DROP TABLE [pa].[dpx_datos_prom_xiii]
GO

/****** Object:  Table [pa].[dpx_datos_prom_xiii]    Script Date: 16-01-2017 2:50:38 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [pa].[dpx_datos_prom_xiii](
	[dpx_codcia] [INT] NULL,
	[dpx_codtpl] [INT] NULL,
	[dpx_codppl] [INT] NULL,
	[dpx_codemp] [INT] NULL,
	[dpx_prom_salario] [NUMERIC](12, 2) NULL,
	[dpx_prom_gasto_rep] [NUMERIC](12, 2) NULL,
	[dpx_dias_salario] [INT] NULL,
	[dpx_dias_gasto_rep] [INT] NULL
) ON [PRIMARY]

GO


