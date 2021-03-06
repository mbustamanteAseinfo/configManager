IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_archivo_anexo03')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_archivo_anexo03]
GO
/****** Object:  StoredProcedure [pa].[rpe_archivo_anexo03]    Script Date: 11/22/2016 2:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [pa].[rpe_archivo_anexo03]
   @codcia  int,
   @anio    int,
   @mes     int = null,
   @coduni	int = null,
   @verAcumulado varchar(1) = null
as
begin

-- execute dbo.rpe_archivo_anexo03 1, 2012, null, null

set nocount on
set dateformat dmy

set @verAcumulado = coalesce(@verAcumulado, 'S')

select	convert(varchar, declara_ingresos_cod) + CHAR(9) + 
		convert(varchar, rpe_tipo_cod) + CHAR(9) +
		convert(varchar, pa.fn_setFormatoCedulaDgi(rpe_doc_tipo)) + CHAR(9) +
		convert(varchar, rpe_nit) + CHAR(9) +
		rpe_nombre_nit + CHAR(9) + 
		convert(varchar, grupo_cod) + CHAR(9) +
		convert(varchar, dependientes) + CHAR(9) +
		convert(varchar, meses) + CHAR(9) +
		convert(varchar, neto) + CHAR(9) + 
		convert(varchar, salario_especie) + CHAR(9) + 
		convert(varchar, ingresosGR) + CHAR(9) +
		convert(varchar, ingresosSalarioSinRetencion) + CHAR(9) +
		convert(varchar, descuentos_renta) + CHAR(9) + 
		convert(varchar, educativo) + CHAR(9) +
		convert(varchar, interes_h) + CHAR(9) +
		convert(varchar, interes_e) + CHAR(9) +
		convert(varchar, p_seg_h) + CHAR(9) +
		convert(varchar, aporte_jubilacion) + CHAR(9) + 
		convert(varchar, col1216) + CHAR(9) + -- total deducciones
		convert(varchar, gravable) + CHAR(9) +
		convert(varchar, impuesto) + CHAR(9) +
		convert(varchar, renta_gr) + CHAR(9) + 
		convert(varchar, exencion_ley6_2005) + CHAR(9) +
		convert(varchar, renta) + CHAR(9) +
		convert(varchar, renta_gr) + CHAR(9) +
		convert(varchar, ajuste_emp) + CHAR(9) +
		--convert(varchar, col24_28) + CHAR(9) +
		convert(varchar, col2528) + CHAR(9) +
		convert(varchar, ajuste_fisco) + CHAR(9) +
		convert(varchar, favor_empleado)
		LINEA, rpe_nombre_nit
from pa.fn_anexo03 (@codcia, @anio, @mes, @coduni, @verAcumulado, 'A')

end

GO
