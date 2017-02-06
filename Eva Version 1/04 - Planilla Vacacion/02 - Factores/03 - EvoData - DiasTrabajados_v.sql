/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 4:15 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '6c388dd7-fcea-46cf-904b-a8f7734e44c4' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('6c388dd7-fcea-46cf-904b-a8f7734e44c4','DiasTrabajados_v','Almacena la cantidad de días trabajados por el empleado en el período','Function DiasTrabajados_v()

DiasTrabajados_v = 0

End Function','double','pa',0);

commit transaction;
