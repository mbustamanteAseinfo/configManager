/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 2:39 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '8715BE23-2AD6-41AA-836C-E015C4BF9F71' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('8715BE23-2AD6-41AA-836C-E015C4BF9F71','SegEducativo_aju','Cálculo del descuento del Seguro Educativo','Function SegEducativo_aju()

cuota = 0
patronal = 0

base = cdbl(Factores("SegEducativoBase_aju").Value)


if base >= 0.01 then
   por_cuota = cDbl(ParametrosSeguroEducativo.Fields("pge_seg_educativo_por_desc").Value)
   pat_cuota = cDbl(ParametrosSeguroEducativo.Fields("pge_seg_educativo_por_pat").Value)
   
   cuota = round(base * por_cuota / 100.0 + 0.00001,2)
   if cuota < 0 then cuota = 0
 
   patronal = round(base * pat_cuota / 100.0 + 0.00001 , 4)
   if patronal < 0 then patronal = 0
end if

''cuota = round(cuota*100.00 + 0.100)/100
cuota = round(cuota+ 0.000000001, 2)

'' Inserta el registro en la tabla de descuentos
if cuota > 0 and not isnull(Factores("SegEducativo_aju").CodTipoDescuento) then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario_Ajustes.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegEducativo_aju").CodTipoDescuento, _
                               cuota, patronal, base , _
                               "PAB", _
                               0, "Dias"
end if

SegEducativo_aju = cuota

End Function
','double','pa',0);

commit transaction;
