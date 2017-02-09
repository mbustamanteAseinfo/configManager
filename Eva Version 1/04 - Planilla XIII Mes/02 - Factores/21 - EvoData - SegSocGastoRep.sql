/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 3:14 PM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = 'f3da6f34-74ef-4311-9002-002ab7099e02';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('f3da6f34-74ef-4311-9002-002ab7099e02','SegSocGastoRep','Cuota de seguro social para los gastos de representación','Function SegSocGastoRep()
isss_gr = 0

''if 1 = 2 then
isss_gr_patronal = 0
patEspecial = 0

'' JR (ASEINFO GT) SE COMENTO ESTAS DOS INSTRUCCIONES 
'' PORQUE NO SE UTILIZAN
''pat_espec = cDbl(ParametrosCuotaISSS.Fields("pge_por_aporteesp_ss").Value)
''patEspecial = (pat_espec / 100) * (Factores("SegSocialGR_BaseCalc").Value)

'' Si la base del seguro social de gastos de representación es mayor que cero, calcula el descuento
if not isnull(Factores("SegSocGastoRep").CodTipoDescuento) and Factores("SegSocialGR_BaseCalc").Value > 0 then
   isss_gr = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_decimo").Value) / 100)
   isss_gr_patronal = Factores("SegSocialGR_BaseCalc").Value * (cDbl(ParametrosCuotaISSS.Fields("pge_isss_por_desc_pat_decimo").Value) / 100)

   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("SegSocGastoRep").CodTipoDescuento, _
                               isss_gr, isss_gr_patronal, Factores("SegSocialGR_BaseCalc").Value , "PAB", 0,""
end if


'' Almacena en las reservas el aporte patronal de seguro social
if not isnull(Factores("SeguroSocialPatrono_d").CodTipoReserva) and isss_gr_patronal > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SeguroSocialPatrono_d").CodTipoReserva, _
                             isss_gr_patronal, "PAB", 0, ""
end if


'' Almacena en las reservas el aporte patronal ESPECIAL de seguro social
if not isnull(Factores("SSPatronalEspecial").CodTipoReserva) and patEspecial > 0 then
   agrega_reservas_historial Agrupadores, _
                             ReservasEstaPlanilla, _
                             Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                             Pla_Periodo.Fields("PPL_CODPPL").Value, _
                             Factores("SSPatronalEspecial").CodTipoReserva, _
                             patEspecial, "PAB", 0, ""
end if

''end if
SegSocGastoRep = isss_gr
End Function','double','pa',0);

commit transaction;
