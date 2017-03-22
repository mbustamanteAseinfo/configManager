
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.vac_vacacion')
                    AND type IN ( N'S', N'U' ) )
					begin
ALTER TABLE [pa].[vac_vacacion] DROP CONSTRAINT [pk_pa_vac_];
alter table [pa].[vac_vacacion] DROP CONSTRAINT [fk_salppl_pa_vac_];
ALTER TABLE [pa].[vac_vacacion] DROP CONSTRAINT [fk_expemp_pa_vac_];

/****** Object:  Table [pa].[dco_datos_contables]    Script Date: 16-01-2017 2:20:24 PM ******/
DROP TABLE [pa].[vac_vacacion];
end
GO
CREATE TABLE pa.vac_vacacion (
   vac_codigo bigint identity(1,1) not null,
   vac_codppl int not null,
   vac_codemp int not null,
   vac_DiasQuincena_v float not null,
   vac_DiasTrabajados_v float not null,
   vac_SalarioActual_v float not null,
   vac_SueldoQuincenal_v float not null,
   vac_GastoRepresentacion_v float not null,
   vac_OtrosIngresos_v float not null,
   vac_SalarioBruto_v float not null,
   vac_SSBaseCalculo_v float not null,
   vac_SeguroSocialPatrono_v float not null,
   vac_SeguroSocial_v float not null,
   vac_SegEducativoBase_v float not null,
   vac_SegEducativoPatronal_v float not null,
   vac_SegEducativo_v float not null,
   vac_ISRBaseCalculo_v float not null,
   vac_ISRBaseCalculoGRep_v float not null,
   vac_DevolucionDescRenta_v float not null,
   vac_CreditoISRGastoRep_v float not null,
   vac_ISR_v float not null,
   vac_ISR_GASTO_REP_v float not null,
   vac_OtrosDescuentos_v float not null,
   vac_DescCiclicos_v float not null,
   vac_SalarioNeto_v float not null
);
alter table pa.vac_vacacion add constraint pk_pa_vac_ primary key (vac_codigo);
alter table pa.vac_vacacion add constraint fk_salppl_pa_vac_ foreign key (vac_codppl) references sal.ppl_periodos_planilla (ppl_codigo);
alter table pa.vac_vacacion add constraint fk_expemp_pa_vac_ foreign key (vac_codemp) references exp.emp_empleos (emp_codigo);

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de días del período para el empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_DiasQuincena_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Almacena la cantidad de días trabajados por el empleado en el período', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_DiasTrabajados_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Actual', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SalarioActual_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario de la Quincena', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SueldoQuincenal_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor de Gastos de Representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_GastoRepresentacion_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Otros Ingresos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_OtrosIngresos_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del Salario Bruto', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SalarioBruto_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Representa el salario sobre el cual se calcula el descuento de Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SSBaseCalculo_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculo del Seguro Social del Patrono', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SeguroSocialPatrono_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del descuento del Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SeguroSocial_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SegEducativoBase_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Parte Patronal del Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SegEducativoPatronal_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del Descuento de Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SegEducativo_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_ISRBaseCalculo_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para calculo de renta para gastos de representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_ISRBaseCalculoGRep_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Devolucion por Descuento de Renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_DevolucionDescRenta_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del Descuento por Gasto de Representacion', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_CreditoISRGastoRep_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento de Impuesto sobre la Renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_ISR_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Factor encargado de calcular el impuesto sobre la renta aplicado al Gasto de Representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_ISR_GASTO_REP_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Procesa Otros Descuentos asociados al periodo de pago', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_OtrosDescuentos_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Detalle de Descuentos Cíclicos para Vacaciones', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_DescCiclicos_v';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Neto a Pagar al Empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'vac_vacacion', @level2type = N'COLUMN', @level2name = N'vac_SalarioNeto_v';

