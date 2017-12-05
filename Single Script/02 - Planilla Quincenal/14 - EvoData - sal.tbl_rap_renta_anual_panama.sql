
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'sal.rap_renta_anual_panama')
                    AND type IN ( N'S', N'U' ) )
/****** Object:  Table [sal].[rap_renta_anual_panama]    Script Date: 16-01-2017 11:26:10 AM ******/
DROP TABLE [sal].[rap_renta_anual_panama]
GO

/****** Object:  Table [sal].[rap_renta_anual_panama]    Script Date: 16-01-2017 11:26:10 AM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [sal].[rap_renta_anual_panama](
	[rap_codcia] [INT] NULL,
	[rap_codtpl] [INT] NULL,
	[rap_codppl] [INT] NULL,
	[rap_codemp] [INT] NULL,
	[rap_acumulado] [MONEY] NULL,
	[rap_proyectado] [MONEY] NULL,
	[rap_ingreso_planilla] [MONEY] NULL,
	[rap_retenido] [MONEY] NULL,
	[rap_desc_legal] [MONEY] NULL,
	[rap_a_descontar] [MONEY] NULL,
	[rap_periodos_restantes] [REAL] NULL,
	[RAP_XIII_PROY] [MONEY] NULL,
	[RAP_PENDIENTES_DECIMO] [FLOAT] NULL,
	[rap_renta_anual] [MONEY] NULL,
	[rap_neto_anual] [MONEY] NULL
) ON [PRIMARY]

GO


