/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:40 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '52B98440-8B49-4F68-82D8-5A759D306FFD';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('52B98440-8B49-4F68-82D8-5A759D306FFD','ISRBaseCalculoGRep_aju','Base cálculo para cálculo de renta del gasto de representación','Function ISRBaseCalculoGRep_aju()

base = 0

base = Agrupadores("IngresosRentaGRepPTY").Value 

if base < 0 then
   base = 0
end if

ISRBaseCalculoGRep_aju = base

End Function
','double','pa',0);

commit transaction;
