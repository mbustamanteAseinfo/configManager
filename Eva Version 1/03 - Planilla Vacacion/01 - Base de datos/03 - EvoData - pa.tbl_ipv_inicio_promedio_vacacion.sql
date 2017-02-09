IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.ipv_inicio_promedio_vacacion')
                    AND type IN ( N'S', N'U' ) )

/****** Object:  Table [pa].[ipv_inicio_promedio_vacacion]    Script Date: 16-01-2017 3:28:27 PM ******/
DROP TABLE [pa].[ipv_inicio_promedio_vacacion]
GO

/****** Object:  Table [pa].[ipv_inicio_promedio_vacacion]    Script Date: 16-01-2017 3:28:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [pa].[ipv_inicio_promedio_vacacion](
	[ipv_codigo] [INT] IDENTITY(1,1) NOT NULL,
	[ipv_codppl] [INT] NOT NULL,
	[ipv_tipo_ingreso] [VARCHAR](1) NOT NULL,
	[ipv_codemp] [INT] NOT NULL,
	[ipv_fecha_ini] [DATETIME] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO


