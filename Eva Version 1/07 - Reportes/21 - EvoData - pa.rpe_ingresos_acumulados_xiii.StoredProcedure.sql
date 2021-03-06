IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.rpe_ingresos_acumulados_xiii')
                    AND type IN ( N'P', N'PC' ) )

DROP PROCEDURE [pa].[rpe_ingresos_acumulados_xiii]
GO
/****** Object:  StoredProcedure [pa].[rpe_ingresos_acumulados_xiii]    Script Date: 11/22/2016 2:39:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [pa].[rpe_ingresos_acumulados_xiii]
   @codcia int,
   @codpla varchar(10),
   @codrsa int
as

-- exec dbo.rpe_ingresos_acumulados_xiii 2, 201203, null, null, 'G'
declare @codtpl int, @codppl int

declare @cia_des varchar(150), @rubro_salarial varchar(1)

-- Tipo de planilla: Decimo Tercero
set @codtpl = 2

SELECT @cia_des = cia_descripcion
FROM eor.cia_companias
WHERE CIA_CODIGO = @codcia

select @codppl = ppl_codigo
from sal.ppl_periodos_planilla
where ppl_codtpl = @codtpl
and ppl_codigo_planilla = @codpla

select @rubro_salarial = convert(varchar(1), rsa_descripcion)
from exp.rsa_rubros_salariales
where rsa_codigo = @codrsa

/*
SELECT @mes1_ini mes1_ini, @mes1_fin mes1_fin, 
       @mes2_ini mes2_ini, @mes2_fin mes2_fin,
       @mes3_ini mes3_ini, @mes3_fin mes3_fin,
       @mes4_ini mes4_ini, @mes4_fin mes4_fin,
       @mes5_ini mes5_ini, @mes5_fin mes5_fin
*/
/*
dic-mitad2
ene
feb
mar
abr-mitad1
abr-mitad2
may
jun
jul
ago-mitad1
ago-mitad2
sep
oct
nov
dic-mitad1
*/

SELECT UNI_CODIGO, uni_descripcion UNI_NOMBRE, EMP_CODIGO, exp_codigo_alternativo EMP_CODIGO_ANTERIOR, exp_nombres_apellidos EMP_NOMBRES_APELLIDOS,
       mes1,
       mes2, mes3, mes4, mes5,
       mes1_nombre, mes2_nombre, mes3_nombre, mes4_nombre, mes5_nombre,
       @cia_des empresa,
       fecha_ini_xiii, fecha_fin_xiii,
       0.00 DIFERENCIA
FROM sal.fn_ingresos_acumulados_xiii (@codcia, @codtpl, @codppl, null, null, @rubro_salarial)
JOIN exp.emp_empleos
ON EMP_CODIGO = CODEMP
join exp.exp_expedientes
on exp_codigo = emp_codexp
JOIN eor.uni_unidades
ON UNI_CODCIA = CODCIA
AND UNI_CODIGO = CODUNI
ORDER BY UNI_CODIGO

-- select * from sal.fn_ingresos_acumulados_xiii (1, 2, 1146, null, null, 'S')

return
GO
