IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.mpv_montos_pago_vacacion')
                    AND type IN ( N'S', N'U' ) )

/****** Object:  Table [pa].[mpv_montos_pago_vacacion]    Script Date: 16-01-2017 3:27:17 PM ******/
DROP TABLE [pa].[mpv_montos_pago_vacacion]
GO

/****** Object:  Table [pa].[mpv_montos_pago_vacacion]    Script Date: 16-01-2017 3:27:17 PM ******/

CREATE TABLE [pa].[mpv_montos_pago_vacacion](
	[mpv_codigo] [INT] IDENTITY(1,1) NOT NULL,
	[mpv_codppl] [SMALLINT] NOT NULL,
	[mpv_tipo_ingreso] [VARCHAR](1) NOT NULL,
	[mpv_codemp] [INT] NOT NULL,
	[mpv_salario] [NUMERIC](12, 2) NULL,
	[mpv_promedio] [NUMERIC](12, 2) NULL,
	[mpv_pagado] [NUMERIC](12, 2) NULL,
	[mpv_pagadas] [BIT] NULL,
	[mpv_dias] [INT] NULL,
	[mpv_num_periodos] [INT] NULL,
 CONSTRAINT [pk_mpv_montos_pago_vac] PRIMARY KEY CLUSTERED 
(
	[mpv_codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO


