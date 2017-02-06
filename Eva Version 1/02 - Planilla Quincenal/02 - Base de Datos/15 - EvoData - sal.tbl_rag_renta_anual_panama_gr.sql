IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.rag_renta_anual_panama_gr')
                    AND type IN ( N'S', N'U' ) )

/****** Object:  Table [sal].[rag_renta_anual_panama_gr]    Script Date: 16-01-2017 11:26:48 AM ******/
DROP TABLE [sal].[rag_renta_anual_panama_gr]
GO

/****** Object:  Table [sal].[rag_renta_anual_panama_gr]    Script Date: 16-01-2017 11:26:48 AM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [sal].[rag_renta_anual_panama_gr](
	[rag_codcia] [INT] NULL,
	[rag_codtpl] [INT] NULL,
	[rag_codppl] [INT] NULL,
	[rag_codemp] [INT] NULL,
	[rag_acumulado] [MONEY] NULL,
	[rag_proyectado] [MONEY] NULL,
	[rag_ingreso_planilla] [MONEY] NULL,
	[rag_retenido] [MONEY] NULL,
	[rag_desc_legal] [MONEY] NULL,
	[rag_a_descontar] [MONEY] NULL,
	[rag_periodos_restantes] [REAL] NULL,
	[rag_decimos_restantes] [REAL] NULL
) ON [PRIMARY]

GO


