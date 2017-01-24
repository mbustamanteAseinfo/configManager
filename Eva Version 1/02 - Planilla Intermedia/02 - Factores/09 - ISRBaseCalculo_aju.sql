/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:40 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'C2EB06BF-4002-4628-8E86-5B1C88CC0F6D';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('C2EB06BF-4002-4628-8E86-5B1C88CC0F6D','ISRBaseCalculo_aju','Base para cálculo de renta del salario','Function ISRBaseCalculo_aju()

base = 0

base = Agrupadores("IngresosRentaPTY").Value

if base < 0 then
   base = 0
end if

ISRBaseCalculo_aju = base

End Function
','double','pa',0);

commit transaction;
