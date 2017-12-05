/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:09 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '3d8f0d05-5f7c-4783-8f26-e8516fcf7202' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('3d8f0d05-5f7c-4783-8f26-e8516fcf7202','DiasTrabajados_d','Almacena la cantidad de días trabajados por el empleado en el período','Function DiasTrabajados_d()

DiasTrabajados_d = 0

End Function','double','pa',0);

commit transaction;
