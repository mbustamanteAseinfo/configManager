
SET NOCOUNT ON
 
SET IDENTITY_INSERT [exp].[ese_estructura_sal_empleos] ON
GO
 
 
IF NOT EXISTS (SELECT 1 FROM [exp].[ese_estructura_sal_empleos] WHERE ese_codigo=1)
BEGIN
	PRINT 'Inserting values into [ese_estructura_sal_empleos] 1'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	INSERT [exp].[ese_estructura_sal_empleos] ([ese_codigo], [ese_codemp], [ese_codrsa], [ese_valor], [ese_codmon], [ese_valor_hora], [ese_num_horas_x_mes], [ese_exp_valor], [ese_valor_anterior], [ese_fecha_inicio], [ese_fecha_fin], [ese_estado], [ese_codtig]) VALUES (1, 1, 1, 5000.0000, 'PAB', 20.8333, 500.0000, 'Mensual', 0.0000, '2001-09-16 00:00:00', NULL, 'V', 1)
END

 
SET IDENTITY_INSERT [exp].[ese_estructura_sal_empleos] OFF
GO
SET NOCOUNT OFF

