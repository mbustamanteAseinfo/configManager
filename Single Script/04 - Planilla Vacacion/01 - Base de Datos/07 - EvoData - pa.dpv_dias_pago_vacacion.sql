IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.dpv_dias_pago_vacacion')
                    AND type IN ( N'S', N'U' ) )
					begin

ALTER TABLE [pa].[dpv_dias_pago_vacacion] DROP CONSTRAINT [fk_salppl_padpv];

ALTER TABLE [pa].[dpv_dias_pago_vacacion] DROP CONSTRAINT [fk_accvac_padpv];

/****** Object:  Table [pa].[dpv_dias_pago_vacacion]    Script Date: 16-01-2017 3:54:42 PM ******/
DROP TABLE [pa].[dpv_dias_pago_vacacion];
end
GO

/****** Object:  Table [pa].[dpv_dias_pago_vacacion]    Script Date: 16-01-2017 3:54:42 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [pa].[dpv_dias_pago_vacacion](
	[dpv_codigo] [INT] IDENTITY(1,1) NOT NULL,
	[dpv_codvac] [INT] NULL,
	[dpv_coddva] [INT] NULL,
	[dpv_codppl] [INT] NOT NULL,
	[dpv_dias] [REAL] NOT NULL,
	[dpv_planilla_autorizada] [BIT] NOT NULL,
 CONSTRAINT [PK_dpv_dias_pago_vacacion] PRIMARY KEY CLUSTERED 
(
	[dpv_codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [pa].[dpv_dias_pago_vacacion]  WITH CHECK ADD  CONSTRAINT [fk_accvac_padpv] FOREIGN KEY([dpv_codvac])
REFERENCES [acc].[vac_vacaciones] ([vac_codigo])
GO

ALTER TABLE [pa].[dpv_dias_pago_vacacion] CHECK CONSTRAINT [fk_accvac_padpv]
GO

ALTER TABLE [pa].[dpv_dias_pago_vacacion]  WITH CHECK ADD  CONSTRAINT [fk_salppl_padpv] FOREIGN KEY([dpv_codppl])
REFERENCES [sal].[ppl_periodos_planilla] ([ppl_codigo])
GO

ALTER TABLE [pa].[dpv_dias_pago_vacacion] CHECK CONSTRAINT [fk_salppl_padpv]
GO


