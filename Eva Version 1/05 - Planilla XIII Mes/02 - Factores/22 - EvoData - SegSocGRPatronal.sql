/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:14 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '1da69547-e0e1-450f-aea7-901248e76a99' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('1da69547-e0e1-450f-aea7-901248e76a99','SegSocGRPatronal','Aporte patronal al seguro social de gastos de representación','Function SegSocGRPatronal()
isss_gr_patronal = 0.00

''if 1 = 2 then
'' Si la base del seguro social de gastos de representación es mayor que cero, calcula el descuento
if  not isnull(Factores("SegSocGRPatronal").CodTipoReserva) and (Factores("SegSocialGR_BaseCalc").Value > 0) then
   isss_gr_patronal = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value) / 100)

   if isss_gr_patronal > 0 then
      agrega_reservas_historial Agrupadores, _
                                ReservasEstaPlanilla, _
                                Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                                Pla_Periodo.Fields("PPL_CODPPL").Value, _
                                Factores("SegSocGRPatronal").CodTipoReserva, _
                                isss_gr_patronal, "PAB", 0, ""
   end if
end if
''end if

SegSocGRPatronal = isss_gr_patronal
End Function','double','pa',0);

commit transaction;
