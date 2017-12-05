IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.aupla_autoriza_planilla_vac')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla_vac]    Script Date: 16-01-2017 3:45:59 PM ******/
DROP PROCEDURE [pa].[aupla_autoriza_planilla_vac]
GO

/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla_vac]    Script Date: 16-01-2017 3:45:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [pa].[aupla_autoriza_planilla_vac]
   @codppl INT,
   @userName VARCHAR(100) = NULL
AS

/*
 * Procedimiento para autorizacion de planillas
 * --------------------------------------------
 *
 * Este procedimiento marca como procesadas las transacciones registradas y autorizadas
 * para el pago de planilla. Marca el periodo como autorizado y genera el próximo.
 *
 * ESTE PROCESO ES IRREVERSIBLE !!!
 *
*/

set nocount on

--*
--* Verifica los parámetros
--*
set @userName = isnull(@userName, system_user)

begin transaction


declare @codtpl int,@codtplVisual varchar(3),@codcia int, @anio int,@mes int,@frecuencia int

select @codtpl = ppl_codtpl,	
		@codtplVisual = tpl_codigo_visual ,
		@codcia = tpl_codcia,
		@anio = ppl_anio,
		@mes = ppl_mes,
		@frecuencia = ppl_frecuencia
  from sal.ppl_periodos_planilla  
  join sal.tpl_tipo_planilla on tpl_codigo  = ppl_codtpl
 where ppl_codigo  =  @codppl

--*
--* Marca el período como autorizado
--*
update sal.ppl_periodos_planilla 
set ppl_estado = 'Autorizado',
	ppl_fecha_modificacion = getdate(),
	ppl_usuario_modificacion = @userName
where ppl_codigo = @codppl

--*
--* Elimina las tablas temporales de la formulación
--*
delete 
from tmp.inn_ingresos
where inn_codppl = @codppl

delete 
from tmp.dss_descuentos
where dss_codppl = @codppl

delete 
from tmp.res_reservas
where res_codppl = @codppl

--*
--* Marca las transacciones aplicadas en planilla, como procesadas
--*
update acc.amo_amonestaciones 
set amo_planilla_autorizada = 1 
where amo_codppl_suspension = @codppl
	and amo_aplicado_planilla = 1
	and amo_ignorar_en_planilla = 0
	and amo_planilla_autorizada = 0
	and amo_estado = 'Autorizado'

update sal.cdc_cuotas_descuento_ciclico 
set cdc_planilla_autorizada = 1 
where cdc_codppl = @codppl
	and cdc_aplicado_planilla = 1
	and cdc_planilla_autorizada = 0

update sal.cec_cuotas_extras_desc_ciclico 
set cec_planilla_autorizada = 1 
where cec_codppl = @codppl
	and cec_aplicado_planilla = 1
	and cec_planilla_autorizada = 0

update sal.cic_cuotas_ingreso_ciclico 
set cic_planilla_autorizada = 1 
where cic_codppl = @codppl
	and cic_aplicado_planilla = 1
	and cic_planilla_autorizada = 0

update acc.dva_dias_vacacion 
set dva_planilla_autorizada = 1 
where dva_codppl = @codppl
	and dva_aplicado_planilla = 1
	and dva_planilla_autorizada = 0

update sal.ext_horas_extras 
set ext_planilla_autorizada = 1 
where ext_codppl = @codppl
	and ext_aplicado_planilla = 1
	and ext_ignorar_en_planilla = 0
	and ext_planilla_autorizada = 0
	and ext_estado = 'Autorizado'

-- Marca como procesados los períodos de incapacidad
update acc.pie_periodos_incapacidad 
set pie_planilla_autorizada = 1 
where pie_codppl = @codppl
	and pie_aplicado_planilla = 1
	and pie_planilla_autorizada = 0

-- Marca como procesados la tabla de otros ingresos
update sal.oin_otros_ingresos 
set oin_planilla_autorizada = 1 
where oin_codppl = @codppl
	and oin_aplicado_planilla = 1
	and oin_ignorar_en_planilla = 0
	and oin_planilla_autorizada = 0
	and oin_estado = 'Autorizado'

-- Marca como procesados la tabla de otros descuentos
update sal.ods_otros_descuentos 
set ods_planilla_autorizada = 1 
where ods_codppl = @codppl
	and ods_aplicado_planilla = 1
	and ods_ignorar_en_planilla = 0
	and ods_planilla_autorizada = 0
	and ods_estado = 'Autorizado'

-- Marca como procesados los registros de servicios realizados
update sal.sre_servicios_realizados 
set sre_planilla_autorizada = 1 
where sre_codppl = @codppl
	and sre_aplicado_planilla = 1
	and sre_ignorar_en_planilla = 0
	and sre_planilla_autorizada = 0
	and sre_estado = 'Autorizado'

update sal.tnn_tiempos_no_trabajados 
set tnn_planilla_autorizada = 1 
where tnn_codppl = @codppl
	and tnn_aplicado_planilla = 1
	and tnn_ignorar_en_planilla = 0
	and tnn_planilla_autorizada = 0
	and tnn_estado = 'Autorizado'

--*
--* Actualiza el total pagado de los ingresos ciclicos
--* y cambia el estado cuando ya terminaron
--*
update sal.igc_ingresos_ciclicos
   set igc_total_pagado = isnull(total_pagado, 0),
       igc_activo = case when igc_monto_indefinido = 0 and 
                              (isnull(total_pagado, 0) >= igc_monto or isnull(maxima_cuota, 0) >= igc_numero_cuotas) 
                          then 0 
                          else 1 
                    end
  from sal.igc_ingresos_ciclicos
  left join (
        select cic_codigc, sum(cic_valor_cuota) total_pagado, max(cic_numero_cuota) maxima_cuota
          from sal.cic_cuotas_ingreso_ciclico
         where cic_aplicado_planilla = 1
           and cic_planilla_autorizada = 1
         group by cic_codigc) cic on cic_codigc = igc_codigo
 where igc_activo = 1
   and exists (
        select null
          from sal.cic_cuotas_ingreso_ciclico
          where cic_codppl = @codppl
            and cic_aplicado_planilla = 1
            and cic_planilla_autorizada = 1)
   
--*
--* Actualiza el total cobrado de los descuentos ciclicos
--* y cambia el estado cuando ya terminaron
--*
update sal.dcc_descuentos_ciclicos
   set dcc_total_cobrado = isnull(total_cobrado, 0) + isnull(total_extras, 0),
       dcc_total_no_cobrado = isnull(total_no_cobrado, 0),
       dcc_activo = case when dcc_monto_indefinido = 0 and 
                              ((isnull(total_cobrado, 0) + isnull(total_extras, 0)) >= dcc_monto or isnull(maxima_cuota, 0) >= dcc_numero_cuotas)
                          then 0 
                          else 1
                    end
  from sal.dcc_descuentos_ciclicos
  left join (
        select cdc_coddcc cobrado_coddcc, sum(cdc_valor_cobrado) total_cobrado, max(cdc_numero_cuota) maxima_cuota
          from sal.cdc_cuotas_descuento_ciclico
         where cdc_aplicado_planilla = 1
           and cdc_planilla_autorizada = 1
         group by cdc_coddcc) cobrado on cobrado_coddcc = dcc_codigo
  left join (
        select cdc_coddcc nocobrado_coddcc, sum(cdc_valor_no_cobrado) total_no_cobrado
          from sal.cdc_cuotas_descuento_ciclico
         where cdc_aplicado_planilla = 1
           and cdc_planilla_autorizada = 1
         group by cdc_coddcc) nocobrado on nocobrado_coddcc = dcc_codigo
  left join (
        select cec_coddcc extra_coddcc, sum(cec_valor_cuota) total_extras
          from sal.cec_cuotas_extras_desc_ciclico
         where cec_aplicado_planilla = 1
           and cec_planilla_autorizada = 1
         group by cec_coddcc) extras on extra_coddcc = dcc_codigo
 where dcc_activo = 1
   and exists (
        select null
          from sal.cdc_cuotas_descuento_ciclico
         where cdc_codppl = @codppl
           and cdc_aplicado_planilla = 1
           and cdc_planilla_autorizada = 1
           and cdc_coddcc  = dcc_codigo)
    or exists (
        select null
          from sal.cec_cuotas_extras_desc_ciclico
         where cec_codppl = @codppl
           and cec_aplicado_planilla = 1
           and cec_planilla_autorizada = 1
           and cec_coddcc = dcc_codigo)
	
 --FONDO DE INCAPACIDAD 
exec pa.GenPla_Genera_Fondo_Incapacidad @codppl, @userName

--***************************************************************
---Los registros que fueron procesados para pagar planilla de vacaciones
update acc.dva_dias_vacacion
	set dva_planilla_autorizada = 1
where dva_codppl = @codppl

update pa.dpv_dias_pago_vacacion
	set dpv_planilla_autorizada = 1
where dpv_codppl = @codppl

--***************************************************************
Declare @tpl_tipo varchar(15),
		@tpl_aplicacion varchar(15),
		@ppl_fecha_ini datetime,
		@ppl_fecha_fin datetime,
		@ppl_frecuencia int,
		@new_codppl int,
		@tpl_total_periodos smallint,
		@tpl_periodo smallint

-- Obtiene los datos del periodo de pago
   select @ppl_fecha_ini = ppl_fecha_ini,
          @ppl_fecha_fin = ppl_fecha_fin,
          @frecuencia = ppl_frecuencia,
		  @tpl_tipo       = tpl_frecuencia,
		  @tpl_aplicacion = tpl_aplicacion,
		  @new_codppl = cast(ppl_codigo_planilla as int),
		  @tpl_periodo = tpl_num_periodo,
		  @tpl_total_periodos = tpl_total_periodos
     from sal.ppl_periodos_planilla
	 join sal.tpl_tipo_planilla on tpl_codigo = ppl_codtpl
    where tpl_codcia = @codcia 
	and ppl_codtpl = @codtpl 
	and ppl_codigo = @codppl
	

-- Genera nuevo período de vacaciones
IF 1 = 2
BEGIN

   if @tpl_tipo = 'Mensual' begin
     if @frecuencia = 1 begin
       set @ppl_fecha_ini = @ppl_fecha_fin + 1
	   set @ppl_fecha_fin = gen.fn_LAST_DAY(@ppl_fecha_ini)
       SET @ppl_frecuencia = 2
	 END
	 ELSE
	 BEGIN
		set @ppl_fecha_fin = dateadd(m, 1, @ppl_fecha_ini) - 1
		set @ppl_fecha_ini = @ppl_fecha_fin - day(@ppl_fecha_fin) + 1
        SET @ppl_frecuencia = 1
	 END
   END

   if @tpl_tipo = 'Quincenal' 
      if @frecuencia = 1 begin
         set @ppl_fecha_ini = @ppl_fecha_fin + 1
         set @ppl_fecha_fin = gen.fn_LAST_DAY(@ppl_fecha_ini)
         SET @ppl_frecuencia = 2
      END
      ELSE
      BEGIN
         set @ppl_fecha_fin = dateadd(m, 1, @ppl_fecha_ini) - 1
         set @ppl_fecha_ini = @ppl_fecha_fin - day(@ppl_fecha_fin) + 1
         SET @ppl_frecuencia = 1
      END

   if @tpl_tipo = 'Catorcenal' begin
      if month(@ppl_fecha_ini) = month(@ppl_fecha_fin + 1)
         set @ppl_frecuencia = @ppl_frecuencia + 1
      ELSE
         SET @ppl_frecuencia = 1

      set @ppl_fecha_ini = @ppl_fecha_fin + 1
      SET @ppl_fecha_fin = DATEADD(d, 13, @ppl_fecha_ini)
   END

   IF @tpl_tipo = 'Semanal' BEGIN
      IF MONTH(@ppl_fecha_ini) = MONTH(@ppl_fecha_fin + 1)
         SET @ppl_frecuencia = @ppl_frecuencia + 1
      ELSE
         SET @ppl_frecuencia = 1

      SET @ppl_fecha_ini = @ppl_fecha_fin + 1
      SET @ppl_fecha_fin = DATEADD(d, 6, @ppl_fecha_ini)
   END

   -- Obtiene el nuevo codigo de planilla
   IF @tpl_periodo = @tpl_total_periodos
      SET @tpl_periodo = 1
   ELSE
      SET @tpl_periodo = @tpl_periodo + 1

   IF @new_codppl > 2000
      --set @codpla = (year(@ppl_fecha_ini) * 100) + @tpl_periodo
      SET @new_codppl = (YEAR(@ppl_fecha_ini)) * 10000 + (MONTH(@ppl_fecha_ini) * 100) + @ppl_frecuencia 
   ELSE 
      -- set @codpla = (year(@ppl_fecha_ini) - 2000) * 100 + @tpl_periodo
      SET @new_codppl = (YEAR(@ppl_fecha_ini) - 2000) * 10000 + (MONTH(@ppl_fecha_ini) * 100) + @ppl_frecuencia 

   -- Ejecuta el insert en la tabla de periodos de planilla
   IF NOT EXISTS(SELECT * FROM sal.ppl_periodos_planilla 
				 JOIN sal.tpl_tipo_planilla ON  tpl_codigo = ppl_codtpl
				 WHERE tpl_codcia = @codcia AND PPL_CODTPL=@codtpl AND ppl_codigo_planilla=CONVERT(VARCHAR(10), @new_codppl))
   BEGIN

	   INSERT INTO sal.ppl_periodos_planilla
		 (PPL_CODTPL, ppl_codigo_planilla, PPL_FECHA_INI, PPL_FECHA_FIN, 
		  PPL_FECHA_PAGO, PPL_ESTADO, PPL_FRECUENCIA, PPL_MES, PPL_ANIO, 
		  PPL_FECHA_CORTE,ppl_usuario_grabacion,ppl_fecha_grabacion)
	   VALUES
		 (@codtpl, @new_codppl, @ppl_fecha_ini, @ppl_fecha_fin,
		  @ppl_fecha_fin, 'Generado', @ppl_frecuencia, MONTH(@ppl_fecha_ini), YEAR(@ppl_fecha_ini),
		  @ppl_fecha_fin, @userName, GETDATE())
   END

   -- Actualiza el contador de periodos de la tabla de tipos de planilla
   UPDATE sal.tpl_tipo_planilla
      SET tpl_num_periodo = @tpl_periodo
    WHERE tpl_codcia = @codcia
      AND tpl_codigo = @codtpl
END

COMMIT TRANSACTION
RETURN

GO


