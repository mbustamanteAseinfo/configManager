CREATE TABLE pa.aju_ajustes (
   aju_codigo bigint identity(1,1) not null,
   aju_codppl int not null,
   aju_codemp int not null,
   aju_aju_EmpleadoParticipa bit not null,
   aju_OtrosIngresos_aju float not null,
   aju_Extraordinario_aju float not null,
   aju_aju_SalarioBruto float not null,
   aju_SSBaseCalculo_aju float not null,
   aju_SeguroSocial_aju float not null,
   aju_SegEducativoBase_aju float not null,
   aju_SegEducativo_aju float not null,
   aju_ISRBaseCalculo_aju float not null,
   aju_aju_ISR money not null,
   aju_ISRBaseCalculoGRep_aju float not null,
   aju_aju_ISR_GR money not null,
   aju_aju_OtrosDescuentos money not null,
   aju_aju_SalarioNeto money not null
);
alter table pa.aju_ajustes add constraint pk_pa_aju_ primary key (aju_codigo);
alter table pa.aju_ajustes add constraint fk_salppl_pa_aju_ foreign key (aju_codppl) references sal.ppl_periodos_planilla (ppl_codigo);
alter table pa.aju_ajustes add constraint fk_expemp_pa_aju_ foreign key (aju_codemp) references exp.emp_empleos (emp_codigo);

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Determina si el empleado participa del calculo de la planilla de ajustes', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_EmpleadoParticipa';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Otros ingresos', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_OtrosIngresos_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Horas extras', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_Extraordinario_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario Bruto', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_SalarioBruto';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para cálculo de Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_SSBaseCalculo_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del descuento del Seguro Social', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_SeguroSocial_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para cálculo de Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_SegEducativoBase_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del descuento del Seguro Educativo', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_SegEducativo_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base para cálculo de renta del salario', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_ISRBaseCalculo_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del impuesto sobre la renta del salario en planilla de ajustes', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_ISR';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base cálculo para cálculo de renta del gasto de representación', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_ISRBaseCalculoGRep_aju';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cálculo del impuesto sobre la renta del salario en planilla quincenal, vacaciones, decimo tecero', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_ISR_GR';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Procesa otros descuentos asociados a la planilla de ajustes', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_OtrosDescuentos';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Salario neto a pagar al empleado en planilla de ajustes', @level0type = N'SCHEMA', @level0name = N'pa', @level1type = N'TABLE', @level1name = N'aju_ajustes', @level2type = N'COLUMN', @level2name = N'aju_aju_SalarioNeto';

