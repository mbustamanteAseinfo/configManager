IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'pa.ter_decimo')
                    AND type IN ( N'S', N'U' ) )

/****** Object:  Table [pa].[ipv_inicio_promedio_vacacion]    Script Date: 16-01-2017 3:28:27 PM ******/
DROP TABLE [pa].[ter_decimo]
GO

CREATE TABLE pa.ter_decimo (
   ter_codigo bigint identity(1,1) not null,
   ter_codppl int not null,
   ter_codemp int not null,
   ter_EmpleadoParticipa_d bit not null,
   ter_DiasQuincena_d float not null,
   ter_DiasTrabajados_d float not null,
   ter_DescAnticipoXIII_GR float not null,
   ter_DescAnticipoXIII float not null,
   ter_Decimo_Tercero_GRep float not null,
   ter_DecimoTercero float not null,
   ter_OtrosIngresos_d float not null,
   ter_OtrosDescuentos_d float not null,
   ter_DescExcesoXIII_GR float not null,
   ter_DescExcesoXIII float not null,
   ter_SegSocialGR_BaseCalc float not null,
   ter_SSBaseCalculo_d float not null,
   ter_ISRBaseCalculo_d float not null,
   ter_ISRBaseCalculoGRep_d float not null,
   ter_ISR_d float not null,
   ter_ISR_GASTO_REP_d float not null,
   ter_SeguroSocialPatrono_d float not null,
   ter_SSPatronalEspecial float not null,
   ter_SeguroSocial_d float not null,
   ter_SegSocGastoRep float not null,
   ter_SegSocGRPatronal float not null,
   ter_SalarioNeto_d float not null
);
alter table pa.ter_decimo add constraint pk_pa_ter_ primary key (ter_codigo);
alter table pa.ter_decimo add constraint fk_salppl_pa_ter_ foreign key (ter_codppl) references sal.ppl_periodos_planilla (ppl_codigo);
alter table pa.ter_decimo add constraint fk_expemp_pa_ter_ foreign key (ter_codemp) references exp.emp_empleos (emp_codigo);

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Determina si el empleado participa del calculo de esta planilla', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_EmpleadoParticipa_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de días del período para el empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DiasQuincena_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Almacena la cantidad de días trabajados por el empleado en el período', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DiasTrabajados_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Aplica el descuento por el anticipo del XIII de GR que haya sido pagado en el período de la planilla', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DescAnticipoXIII_GR';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Aplica el descuento por el anticipo del XIII que haya sido pagado en el período de la planilla', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DescAnticipoXIII';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Factor que Calcula el Valor del Decimo Tercer Mes del Gasto de Representacion.', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_Decimo_Tercero_GRep';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calcula el monto del pago del Decimo Tercero', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DecimoTercero';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Otros ingresos registrados para el pago de la planilla', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_OtrosIngresos_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Otros descuentos de planilla decimo tercero', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_OtrosDescuentos_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento por Exceso XIII pendiente por aplicar del gasto de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DescExcesoXIII_GR';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descuento por Exceso XIII pendiente por aplicar', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_DescExcesoXIII';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Seguro Social de Gastos de Representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SegSocialGR_BaseCalc';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Representa el salario sobre el cual se calcula el descuento de Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SSBaseCalculo_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para el cálculo de renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_ISRBaseCalculo_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base cálculo del impuesto sobre la renta para el caso del gasto de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_ISRBaseCalculoGRep_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del impuesto sobre la renta', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_ISR_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del impuesto sobre la renta sobre el gasto de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_ISR_GASTO_REP_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculo del Seguro Social del Patrono', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SeguroSocialPatrono_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Aporte patronal especial del seguro social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SSPatronalEspecial';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del descuento del Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SeguroSocial_d';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cuota de seguro social para los gastos de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SegSocGastoRep';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Aporte patronal al seguro social de gastos de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SegSocGRPatronal';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Neto a Pagar al Empleado', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'ter_decimo', @level2type = N'COLUMN', @level2name = N'ter_SalarioNeto_d';

