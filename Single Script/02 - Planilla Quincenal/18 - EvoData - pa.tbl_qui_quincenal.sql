IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.qui_quincenal')
                    AND type IN ( N'S', N'U' ) )
/****** Object:  Table [sal].[rap_renta_anual_panama]    Script Date: 16-01-2017 11:26:10 AM ******/
DROP TABLE [pa].[qui_quincenal]
GO
CREATE TABLE pa.qui_quincenal (
   qui_codigo bigint identity(1,1) not null,
   qui_codppl int not null,
   qui_codemp int not null,
   qui_DiasQuincena float not null,
   qui_HorasTrabajadas float not null,
   qui_DiasTrabajados float not null,
   qui_SalarioActual float not null,
   qui_SueldoQuincenal float not null,
   qui_GastoRepresentacion float not null,
   qui_Retroactivo float not null,
   qui_RetroactivoGastoRep float not null,
   qui_DiasIncapacidad float not null,
   qui_DiasDescuentoIncap float not null,
   qui_DescuentoIncapacidad float not null,
   qui_IngresoIncapacidad float not null,
   qui_HorasTNT float not null,
   qui_DescuentoTNT float not null,
   qui_OtrosIngresos float not null,
   qui_DevRenta float not null,
   qui_IngCiclicos float not null,
   qui_Extraordinario float not null,
   qui_OtrosDescAplicaLegal float not null,
   qui_GrabaHistoriales float not null,
   qui_SSBaseCalculo float not null,
   qui_SeguroSocialPatrono float not null,
   qui_SeguroSocial float not null,
   qui_SegEducativoBase float not null,
   qui_SegEducativoPatronal float not null,
   qui_SegEducativo float not null,
   qui_ISRBaseCalculo float not null,
   qui_ISRBaseCalculoGRep float not null,
   qui_DevolucionDescRenta float not null,
   qui_CreditoISRGastoRep float not null,
   qui_ISR float not null,
   qui_ISR_GASTO_REP float not null,
   qui_PatronalProfuturoPA float not null,
   qui_PatronalProfuturoIDM float not null,
   qui_OtrosDescuentos float not null,
   qui_DescCiclicos float not null,
   qui_SalarioNeto float not null
);
alter table pa.qui_quincenal add constraint pk_pa_qui_ primary key (qui_codigo);
alter table pa.qui_quincenal add constraint fk_salppl_pa_qui_ foreign key (qui_codppl) references sal.ppl_periodos_planilla (ppl_codigo);
alter table pa.qui_quincenal add constraint fk_expemp_pa_qui_ foreign key (qui_codemp) references exp.emp_empleos (emp_codigo);

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de días del período para el empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DiasQuincena';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Horas trabajadas en el periodo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_HorasTrabajadas';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Almacena la cantidad de días trabajados por el empleado en el período', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DiasTrabajados';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Actual', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SalarioActual';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario de la Quincena', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SueldoQuincenal';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor de Gastos de Representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_GastoRepresentacion';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retroactivo del salario', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_Retroactivo';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retroactivo del gasto de representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_RetroactivoGastoRep';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dias de Incapacidad', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DiasIncapacidad';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dias Descuento Incapacidad', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DiasDescuentoIncap';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento por Incapacidad', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DescuentoIncapacidad';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Obtiene el monto a pagar en concepto de incapacidad', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_IngresoIncapacidad';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de horas no trabajadas por el empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_HorasTNT';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento por Tiempo no Trabajado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DescuentoTNT';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Otros Ingresos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_OtrosIngresos';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Devolucion de Renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DevRenta';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cuotas por Ingresos Cíclicos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_IngCiclicos';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor total de horas extras', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_Extraordinario';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Procesa Otros Descuentos asociados al periodo de pago afectos a descuentos legales', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_OtrosDescAplicaLegal';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Funcion que graba en las tablas historicas de ingresos, descuentos y reservas los ingresos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_GrabaHistoriales';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Representa el salario sobre el cual se calcula el descuento de Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SSBaseCalculo';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculo del Seguro Social del Patrono', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SeguroSocialPatrono';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del descuento del Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SeguroSocial';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SegEducativoBase';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Parte Patronal del Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SegEducativoPatronal';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del Descuento de Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SegEducativo';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_ISRBaseCalculo';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de renta para gastos de representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_ISRBaseCalculoGRep';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Devolucion por Descuento de Renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DevolucionDescRenta';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del Descuento por Gasto de Representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_CreditoISRGastoRep';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento de Impuesto sobre la Renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_ISR';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Factor encargado de calcular el impuesto sobre la renta aplicado al Gasto de Representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_ISR_GASTO_REP';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculo de aporte patronal AFP PA', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_PatronalProfuturoPA';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cuota patronal profuturo de Indemnizacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_PatronalProfuturoIDM';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Procesa Otros Descuentos asociados al periodo de pago', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_OtrosDescuentos';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Detalle de Descuentos Ciclicos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_DescCiclicos';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Neto a Pagar al Empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'qui_quincenal', @level2type = N'COLUMN', @level2name = N'qui_SalarioNeto';

