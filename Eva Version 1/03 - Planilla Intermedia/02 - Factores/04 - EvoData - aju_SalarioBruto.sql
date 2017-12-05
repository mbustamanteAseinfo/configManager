/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:38 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'd01c3419-19d4-4852-ae64-ffd7371186cf' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('d01c3419-19d4-4852-ae64-ffd7371186cf','aju_SalarioBruto','Salario Bruto','Function aju_SalarioBruto()
aju_SalarioBruto = Factores("OtrosIngresos_aju").Value + _
               Factores("Extraordinario_aju").Value

End Function','double','pa',0);

commit transaction;
