/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:41 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '74A11C69-2905-4645-9CA6-225EF691E0D3';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('74A11C69-2905-4645-9CA6-225EF691E0D3','aju_SalarioNeto','Salario neto a pagar al empleado en planilla de ajustes','Function aju_SalarioNeto()

liquido = Factores("aju_SalarioBruto").Value - _
          	Factores("aju_ISR").Value - _
          	Factores("aju_ISR_GR").Value - _
          	Factores("SegEducativo_aju").Value - _
          	Factores("SeguroSocial_aju").Value - _
          	Factores("aju_OtrosDescuentos").Value

aju_SalarioNeto = liquido

End Function
','money','pa',0);

commit transaction;
