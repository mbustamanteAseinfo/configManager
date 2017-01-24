/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:18 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'ee0880a3-a8f6-4709-a3ab-4976e54ecbaf';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('ee0880a3-a8f6-4709-a3ab-4976e54ecbaf','SalarioBruto_v','Cálculo del Salario Bruto','Function SalarioBruto_v()
var_SalarioBruto = 0.00

var_SalarioBruto = Factores("SueldoQuincenal_v").Value + _
                   Factores("GastoRepresentacion_v").Value + _                   
                   Factores("OtrosIngresos_v").Value

if var_SalarioBruto < 0 then
   var_SalarioBruto = 0.00
end if

SalarioBruto_v = var_SalarioBruto
End Function','double','pa',0);

commit transaction;
